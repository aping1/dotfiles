
#_SCRIPT_DIR="$(cd $(dirname "$0") &>/dev/null; pwd -P;)"
#source ${_SCRIPT_DIR}/helpers.zsh # Dp you want 

alias tmux-pane='tmux display-message -p "#{pane_index}"'

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

