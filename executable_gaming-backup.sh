#!/bin/bash
set -e

SCRIPT_NAME=$(basename "$0")
BACKUP_DIR="${HOME}/gaming-backups"

usage() {
  echo "Usage: $SCRIPT_NAME [backup|restore|gaming] <path1> [path2] ..."
  echo ""
  echo "Backup gaming data to zip files"
  echo ""
  echo "Commands:"
  echo "  backup   <paths>   Backup specified folders to zip"
  echo "  restore  <paths>   Restore folders from zip"
  echo "  gaming             Backup common gaming folders (preset)"
  echo "  list              List available backups"
  echo ""
  echo "Examples:"
  echo "  $SCRIPT_NAME backup ~/.config/unity3d ~/.local/share/UnrealEngine"
  echo "  $SCRIPT_NAME gaming"
  echo "  $SCRIPT_NAME restore unity3d unrealengine renpy"
  echo "  $SCRIPT_NAME list"
  echo ""
  echo "Default backup location: $BACKUP_DIR"
  exit 1
}

mkdir -p "$BACKUP_DIR"

backup_folder() {
  local src="$1"
  local name=$(basename "$src")
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local zip_name="${name}_${timestamp}.zip"
  local zip_path="${BACKUP_DIR}/${zip_name}"
  
  if [ ! -d "$src" ]; then
    echo "Error: '$src' does not exist or is not a directory"
    return 1
  fi
  
  echo "Backing up: $src -> $zip_path"
  zip -r "$zip_path" "$src" -x "*.git*" "Thumbs.db" "desktop.ini" 2>/dev/null || \
    zip -r "$zip_path" "$src"
  
  if [ -f "$zip_path" ]; then
    local size=$(du -h "$zip_path" | cut -f1)
    echo "  Created: $zip_name ($size)"
  else
    echo "  Failed to create backup"
    return 1
  fi
}

restore_folder() {
  local name="$1"
  local zip_file=""
  
  # Find the most recent zip matching the name
  zip_file=$(ls -t "${BACKUP_DIR}/${name}"*.zip 2>/dev/null | head -1)
  
  if [ -z "$zip_file" ]; then
    echo "Error: No backup found for '$name' in $BACKUP_DIR"
    echo "Run '$SCRIPT_NAME list' to see available backups"
    return 1
  fi
  
  local target_name=$(basename "$zip_file" .zip | sed 's/_[0-9]*_[0-9]*$//')
  local target_path="${HOME}/${target_name}"
  
  # Try to determine original path from zip contents
  local original_path=$(unzip -l "$zip_file" 2>/dev/null | head -10 | grep -oP '(\./)?[^/]+/\.\.' | tail -1 | sed 's|/\.\.$||' | sed 's|^\./||')
  
  if [ -n "$original_path" ]; then
    target_path="$original_path"
  fi
  
  echo "Restoring: $zip_file"
  echo "  Target: $target_path"
  
  # Create parent directory if needed
  mkdir -p "$(dirname "$target_path")"
  
  # Remove existing folder if present
  if [ -d "$target_path" ]; then
    read -p "  Remove existing folder? [y/N]: " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
      rm -rf "$target_path"
    else
      echo "  Skipped restore"
      return 0
    fi
  fi
  
  unzip -o "$zip_file" -d "$(dirname "$target_path")"
  echo "  Restored to: $target_path"
}

list_backups() {
  echo "Available backups in $BACKUP_DIR:"
  echo ""
  
  if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo "  No backups found"
    return
  fi
  
  ls -lh "$BACKUP_DIR"/*.zip 2>/dev/null | tail -n +2 | while read -r line; do
    local file=$(echo "$line" | awk '{print $NF}')
    local name=$(basename "$file" .zip | sed 's/_[0-9]*_[0-9]*$//')
    echo "  $name"
    echo "    $(basename "$file")"
    echo "    $(echo "$line" | awk '{print $5}')"
  done
}

backup_gaming() {
  echo "Backing up common gaming folders..."
  local paths=(
    "$HOME/.renpy"
    "$HOME/.config/unity3d"
    "$HOME/.local/share/UnrealEngine"
    "$HOME/.config/EmuDeck"
    "$HOME/.config/heroic"
    "$HOME/.config/PCSX2"
    "$HOME/.config/Ryujinx"
    "$HOME/.config/Cemu"
    "$HOME/.config/Vita3K"
  )
  
  for path in "${paths[@]}"; do
    if [ -d "$path" ]; then
      backup_folder "$path"
    else
      echo "Skipping (not found): $path"
    fi
  done
}

# Main
case "$1" in
  backup)
    shift
    if [ $# -eq 0 ]; then
      echo "Error: No paths specified"
      usage
    fi
    for path in "$@"; do
      # Expand ~ to home
      path="${path/#\~/$HOME}"
      backup_folder "$path"
    done
    echo ""
    echo "Backup complete! Files saved to: $BACKUP_DIR"
    ;;
  restore)
    shift
    if [ $# -eq 0 ]; then
      echo "Error: No backup names specified"
      usage
    fi
    for name in "$@"; do
      restore_folder "$name"
    done
    echo ""
    echo "Restore complete!"
    ;;
  list)
    list_backups
    ;;
  gaming)
    backup_gaming
    echo ""
    echo "Gaming backup complete! Files saved to: $BACKUP_DIR"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "Error: Unknown command '$1'"
    usage
    ;;
esac
