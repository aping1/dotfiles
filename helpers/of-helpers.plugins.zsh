#!/bin/zsh

# If you use #'s for defer and start dates, you'll need to escape the #'s or
# quote the whole string.

function of () {
  if [[ $# -eq 0 ]]; then
    open -a "OmniFocus"
  else
    osascript <<EOT
    tell application "OmniFocus"
      parse tasks into default document with transport text "$@"
    end tell
EOT
  fi
}
