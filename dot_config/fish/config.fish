starship init fish | source
zoxide init fish | source
alias ls="lsd --group-dirs first"
alias ll="lsd -l --group-dirs first"
alias la="lsd -a"
alias lla="lsd -la --group-dirs first"
alias cls="clear"
alias cd..="cd .."
function pf --description 'Fuzzy find and install packages via pacman'
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' \
        | xargs -r sudo pacman -S
end

function af --description 'Fuzzy find and install AUR packages via paru'
    paru -Slq | fzf --multi --preview 'paru -Si {1}' \
        | xargs -r paru -S
end

