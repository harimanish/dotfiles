# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Installation

```bash
# Install chezmoi
curl -sfL https://get.chezmoi.io | sh

# Initialize from this repo
chezmoi init --source=https://github.com/harimanish/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply
```

## Managed Configs

| Tool | Config Location |
|------|-----------------|
| **Fish** | `~/.config/fish/` |
| **Ghostty** | `~/.config/ghostty/` |
| **Neovim (AstroNvim)** | `~/.config/nvim/` |
| **Starship** | `~/.config/starship.toml` |
| **Yazi** | `~/.config/yazi/` |
| **btop** | `~/.config/btop/` |
| **bottom** | `~/.config/bottom/` |
| **mpv** | `~/.config/mpv/` |
| **bat** | `~/.config/bat/` |
| **Zed** | `~/.config/zed/` |

## Requirements

- Fish shell
- Ghostty terminal
- Neovim with AstroNvim
- Starship prompt
- btop, bottom (system monitors)
- mpv (media player)
- bat (cat alternative)
- yazi (file manager)
- Zed editor

Install all dependencies:

```bash
./install-setup.sh
```

Or manually:

```bash
# CachyOS/Arch
sudo pacman -S fish ghostty neovim starship btop bottom mpv bat yazi zed

# Or with paru/yay
paru -S fish ghostty neovim starship btop bottom mpv bat yazi zed
```

## Customization

- Edit source files in `~/.local/share/chezmoi/`
- Run `chezmoi edit <file>` to edit a config
- Run `chezmoi apply` to apply changes
- Run `chezmoi add <file>` to add new files

## License

MIT
