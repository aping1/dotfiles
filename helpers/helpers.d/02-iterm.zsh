
function set_iterm_both_title () {
  [[ -z "$*" ]] && return 1
  local title="${*}"
  title=${title//\\/\\\\}
  title=${title//\"/\\\"}
  title=${title//\%/\%\%}
  printf "\e]0;${title}\a"  # Both tab and window
}
function set_iterm_tab_title() {
  [[ -z "$*" ]] && return 1
  local title="${*}"
  title=${title//\\/\\\\}
  title=${title//\"/\\\"}
  title=${title//\%/\%\%}
  printf "\e]1;${title}\a"  # Tab title
}

function () {
  [[ -z "$*" ]] && return 1
  local title="${*}"
  title=${title//\\/\\\\}
  title=${title//\"/\\\"}
  title=${title//\%/\%\%}
  printf "\e]2;${title}\a"  # Window title
}
