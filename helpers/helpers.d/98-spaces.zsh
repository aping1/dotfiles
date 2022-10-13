

alias current_window_id='yabai -m query --windows --window | jq -re ".id"'

alias current_space_ind='yabai -m query --spaces | jq -re ".[] | select(.visible == 1)"'

alias first_window_on_next_space='yabai -m query --spaces --space $1 | jq -re ".[\"first-window\"]"'

function move_window() {
  local window=$(current_window_id)
  local space_json=$(current_space_ind)
  local currentsSpaceIndex=$(printf -- "$space_json" | jq -re '.["index"]')
  local target=${1:-$(printf -- "${space_json}"  | jq '.id')}
  case $target in
    next)
      target=$(space_id.sh $(( $current_space_indIndex + 1 )))
      ;;
    prev)
      target=$(space_id.sh $(( $current_space_indIndex - 1 )))
      ;;
    smallest)
      target=$(smallest_space)
      ;;
    *)
      ;;
  esac
  yabai -m window --space $target 
  focus_window.sh $window
}


