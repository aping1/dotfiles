export SOURCE_THIS="$(cd $(dirname "${0:-${DOTFILES}/plugins/autocomplete-extra/init.zsh}") &>/dev/null; pwd -P;)/auto-fu.zsh/auto-fu.zsh"
if [[ -s "${SOURCE_THIS}" ]] ; then
    source $SOURCE_THIS

    zstyle ':completion:*:*:-command-:*:functions' group-name functions

# 3) use the _oldlist completer something like below.
# (If you have a lot of completer, please insert _oldlist before _complete.)
zstyle ':completion:*' completer _oldlist _complete

# 4) establish `zle-keymap-select' containing `auto-fu-zle-keymap-select'.
    zle -N zle-keymap-select auto-fu-zle-keymap-select
        # (This enables the afu-vicmd keymap switching coordinates a bit.)
        # *Optionally* you can use the zcompiled file for a little faster loading on
            # every shell startup, if you zcompile the necessary functions.
                #
                #zsh -c 'source $A; source "$SOURCE_THIS"; 
                #    auto-fu-zcompile $A ~/.zsh'

# *1) zcompile the defined functions. (generates ~/.zsh/auto-fu.zwc)
# It is approximately *(6~10) faster if zcompiled, according to this result :)
    #
    zsh -c 'source "$SOURCE_THIS"; 
        auto-fu-zcompile $SOURCE_THIS ~/.zsh' >/dev/null && \
    { source ~/.zsh/auto-fu; auto-fu-install; } || return 0
        zstyle ':auto-fu:highlight' input bold
        zstyle ':auto-fu:highlight' completion fg=black,bold
        zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
        zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
        zstyle ':auto-fu:var' track-keymap-skip opp
        # *3) establish `zle-line-init' and such (same as a few lines above).

        zle-line-init () {auto-fu-init;}; zle -N zle-line-init
        zle -N zle-keymap-select auto-fu-zle-keymap-select
        fi 
