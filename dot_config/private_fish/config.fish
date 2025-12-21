# =========================
#  Starship & Zoxide Setup
# =========================
starship init fish | source
zoxide init fish | source

# =========================
#  Aliases
# =========================
alias ls="lsd --group-dirs first"
alias ll="lsd -l --group-dirs first"
alias la="lsd -a"
alias lt="lsd --tree"
alias lla="lsd -la --group-dirs first"
alias cls="clear"
alias cd..="cd .."
alias ..="cd .."
# alias cd="zoxide"
alias n="nvim"
alias vi="nvim"
alias vim="nvim"
alias nano="nvim"
alias y="yazi"
alias lg="lazygit"
alias ld="lazydocker"


# =========================
#  Fuzzy Find Package Manager Functions
# =========================

# Fuzzy find and install packages via pacman
function pf --description 'Fuzzy find and install packages via pacman'
    set selected (pacman -Slq | fzf --multi --preview 'pacman -Si {1}')
    if test -n "$selected"
        echo "Installing: $selected"
        sudo pacman -S $selected
    else
        echo "No package selected."
    end
end

# Fuzzy find and install AUR packages via paru
function af --description 'Fuzzy find and install AUR packages via paru'
    set selected (paru -Slq | fzf --multi --preview 'paru -Si {1}')
    if test -n "$selected"
        echo "Installing: $selected"
        paru -S $selected
    else
        echo "No package selected."
    end
end


# =========================
#  FZF Integration
# =========================
fzf --fish | source

set -x LANG en_IN.UTF-8
set -x LC_ALL en_IN.UTF-8
set -x EDITOR nvim
set -x VISUAL nvim

