
#_SCRIPT_DIR="$(cd $(dirname "$0") &>/dev/null; pwd -P;)"
#source ${_SCRIPT_DIR}/helpers.zsh # Dp you want 

alias tmux-pane='''tmux display-message -p '#{pane_index}''''
