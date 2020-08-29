#!/usr/bin/env zsh
emulate -L zsh

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

() {
    trap 'unset keycodes' EXIT
    # NOTE: understand keycodes read these
    #   https://invisible-island.net/xterm/terminfo-contents.html#tic-xterm-r6
    #   https://www.ibm.com/support/knowledgecenter/en/ssw_aix_71/filesreference/terminfo.html
    #typeset -A key # Conflicts with zini
    typeset -gA keycodes=(
        BackSpace  "${terminfo[kbs]}"
        Home       "${terminfo[khome]}"
        End        "${terminfo[kend]}"
        Insert     "${terminfo[kich1]}"
        Delete     "${terminfo[kdch1]}"
        Up         "${terminfo[kcuu1]}"
        Down       "${terminfo[kcud1]}"
        Left       "${terminfo[kcub1]}"
        Right      "${terminfo[kcuf1]}"
        PageUp     "${terminfo[kpp]}"
        PageDown   "${terminfo[knp]}"
        BackTab    "${terminfo[kcbt]}"
    )

    # Transistion between vi states faster (default: 4)
    # KEYTIMEOUT=1

    # use the vi navigation keys in menu completion
    bindkey -M menuselect '^n' expand-or-complete
    bindkey -M menuselect '^p' reverse-menu-complete

    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history

    #autoload -U history-search-end
    #zle -N history-beginning-search-backward-end history-search-end
    #bindkey "^[[A" history-beginning-search-backward-end

    bindkey '^[[1;5C' vi-forward-word   # [Ctrl-RightArrow] - move forward one word
    bindkey '^[[1;5D' vi-backward-word  # [Ctrl-LeftArrow]  - move backward one word
    bindkey -s '^[[5~' '' #disable Pgup
    bindkey -s '^[[6~' '' # disable pgdown
    bindkey '^[[3;5~' kill-whole-line # ctrl+del   delete next word

    bindkey -M main '^K' history-beginning-search-backward
    bindkey -M main '^J' history-beginning-search-forward

    bindkey "^[[A" up-line-or-local-history
    bindkey "^[[B" down-line-or-local-history

    bindkey '^[[1;5C' forward-word   # [Ctrl-RightArrow] - move forward one word
    bindkey '^[[1;5D' backward-word  # [Ctrl-LeftArrow]  - move backward one word
}
