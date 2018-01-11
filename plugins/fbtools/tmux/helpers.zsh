#!/usr/local/env zsh
#
# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
function _fb_tmux_helper_get_options() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
function _fb_tmux_helper_display_message() {
	local message="$1"

	# display_duration defaults to 5 seconds, if not passed as an argument
	if [ "$#" -eq 2 ]; then
		local display_duration="$2"
	else
		local display_duration="5000"
	fi

	# saves user-set 'display-time' option
	local saved_display_time=$(get_tmux_option "display-time" "750")

	# sets message display time to 5 seconds
	tmux set-option -gq display-time "$display_duration"

	# displays message
	tmux display-message "$message"

	# restores original 'display-time' value
	tmux set-option -gq display-time "$saved_display_time"
}

function _fb_tmux_helper_get_socket() {
	echo $TMUX | cut -d',' -f1
}

function _fb_tmux_helper_session_exists() {
    : ${SESSION_NAME:="${1:-$(_fb_tmux_helper_get_session)}"}
	tmux has-session -t "=${SESSION_NAME}" >/dev/null 2>&1
}

function _fb_tmux_helper_session_exists_prefix() {
    : ${SESSION_NAME:="${1:-$(_fb_tmux_helper_get_session)}"}
	tmux has-session -t "$SESSION_NAME" >/dev/null 2>&1
}

function _fb_tmux_helper_switch_to_session() {
    : ${SESSION_NAME:="${1:-$(_fb_tmux_helper_get_session)}"}
    [[ "${SESSION_NAME}" == "$(_fb_tmux_helper_get_session)" ]] && return 1
	tmux switch-client -t "${SESSION_NAME}"
}

function _fb_tmux_helper_get_session() {
    tmux display-message -p "#{client_session}"
}

