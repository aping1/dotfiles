
zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect '^n' expand-or-complete
bindkey -M menuselect '^p' reverse-menu-complete

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey -M main '^K' up-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle vi-up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history

down-line-or-local-history() {
    zle set-local-history 1
    zle vi-down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

