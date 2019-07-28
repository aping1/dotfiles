
source auto-fu.zsh

function zle-line-init () {
    auto-fu-init;
}; 
zle -N zle-line-init

# 3) use the _oldlist completer something like below.
zstyle ':completion:*' completer _oldlist _complete
# (If you have a lot of completer, please insert _oldlist before _complete.)
# 4) establish `zle-keymap-select' containing `auto-fu-zle-keymap-select'.
zle -N zle-keymap-select auto-fu-zle-keymap-select
# (This enables the afu-vicmd keymap switching coordinates a bit.)
# *Optionally* you can use the zcompiled file for a little faster loading on
# every shell startup, if you zcompile the necessary functions.
# *1) zcompile the defined functions. (generates ~/.zsh/auto-fu.zwc)
#
if [[ ! -e ~/.zsh/auto-fu ]]; then
A=${HOME}/.dotfiles/plugings/autocomplete-extra/auto-fu.zsh; (\
    zsh -c "source $A;
    auto-fu-zcompile $A ~/.zsh") && source ~/.zsh/auto-fu; auto-fu-install

# *3) establish `zle-line-init' and such (same as a few lines above).
# Note:

# It is approximately *(6~10) faster if zcompiled, according to this result :)
fi
