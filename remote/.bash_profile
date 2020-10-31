#!/bin/bash

[[ -f ~/.fzf.bash ]] && source "${HOME}/.fzf.bash"

alias current_window_id='yabai -m query --windows --window | jq -re ".id"'

alias current_space_ind='yabai -m query --spaces | jq -re ".[] | select(.visible == 1)"'
function first_window_on_next_space()
{
   yabai -m query --spaces --space $1 | jq -re ".[\"first-window\"]"
}
if [[ $(uname) == "Darwin"  && ${TERM} =~ ^xterm ]]; then 
    exec zsh -cl
fi

