#!/usr/bin/env zsh
#
export _SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
#source "${_SCRIPT_PATH}/aliases/develop.sh"


alias dev_server='host $(whoami).sb | head -n1 | awk '\''{print $NF}'\'' | sed '\'' s/\.$//g'\' 
