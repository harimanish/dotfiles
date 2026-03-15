#!/bin/bash
set -e

echo "=== CachyOS + ROG Ally Setup Installer ==="
echo ""

detect_pm() {
  if command -v paru >/dev/null 2>&1; then
    echo "paru"
  elif command -v yay >/dev/null 2>&1; then
    echo "yay"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

install_pkg() {
  local pkg=$1
  local pm=$2
  echo "Installing: $pkg"
  case "$pm" in
    paru|yay)
      $pm -S --needed --noconfirm "$pkg" 2>/dev/null || echo "  Failed: $pkg"
      ;;
    pacman)
      sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || echo "  Failed: $pkg"
      ;;
    *)
      echo "  Unsupported: $pm"
      ;;
  esac
}

PM=$(detect_pm)
echo "Detected package manager: $PM"
echo ""

if [ "$PM" = "unknown" ]; then
  echo "Error: No supported package manager found"
  exit 1
fi

echo "Select installation scope:"
echo "1) Terminal only"
echo "2) Media (mpv, etc.)"
echo "3) All"
echo "4) Full Setup (chezmoi + dotfiles + packages)"
echo "5) Custom"
read -p "Choice [1-5]: " choice

install_chezmoi() {
  echo "Installing chezmoi..."
  if command -v chezmoi >/dev/null 2>&1; then
    echo "  chezmoi already installed"
  else
    curl -sfL https://get.chezmoi.io | sh
  fi
}

init_dotfiles() {
  echo "Initializing dotfiles from GitHub..."
  local dotfiles_dir="$HOME/.local/share/chezmoi"
  
  if [ -d "$dotfiles_dir/.git" ]; then
    echo "  Dotfiles already initialized, updating..."
    cd "$dotfiles_dir"
    git pull origin main 2>/dev/null || git pull
  else
    chezmoi init --source=https://github.com/harimanish/dotfiles.git
  fi
  
  echo "  Applying dotfiles..."
  chezmoi apply
  
  echo "  Copying install script to dotfiles..."
  cp "$0" "$dotfiles_dir/install-setup.sh" 2>/dev/null || true
  cd "$dotfiles_dir"
  git add install-setup.sh 2>/dev/null || true
}

install_terminal() {
  local pkgs="ripgrep fd bat fzf neovim starship fish bottom btop yazi ghostty zed"
  for pkg in $pkgs; do
    install_pkg "$pkg" "$PM"
  done
}

install_media() {
  local pkgs="mpv spotify"
  for pkg in $pkgs; do
    install_pkg "$pkg" "$PM"
  done
}

install_all() {
  install_terminal
  install_media
}

install_full() {
  install_chezmoi
  init_dotfiles
  install_all
}

case "$choice" in
  1) install_terminal ;;
  2) install_media ;;
  3) install_all ;;
  4) install_full ;;
  5)
    echo "Enter packages separated by space:"
    read -a custom_pkgs
    for pkg in "${custom_pkgs[@]}"; do
      install_pkg "$pkg" "$PM"
    done
    ;;
  *) echo "Invalid choice" ;;
esac

echo ""
echo "=== Installation complete ==="
