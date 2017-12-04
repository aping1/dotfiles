#!/usr/bin/env zsh
#
#
export _SCRIPT_DIR="$( cd ${SCRIPT_DIR:-"$(dirname "$0")"} &>/dev/null ; pwd -P )"

#source "${_SCRIPT_DIR}/tasks/init.zsh"


declare -a plugins
source "${_SCRIPT_DIR}/utils.zsh"
plugins=$(find "${_SCRIPT_DIR}"  -mindepth 2 -name "init.zsh" 2>/dev/null)
for PLUGIN_FILE in ${plugins}; do 
    #printf "Sourcing ${PLUGIN_FILE}..."
    source "${PLUGIN_FILE}"
done

function dev_server () {
    if grep -qi NXDOMAIN <<<  "${DEV_SERVER=$(host $(whoami).sb | head -n1)}"; then
        DEV_SERVER="$(echo "${DEV_SERVER}" | awk '{print $NF}' | sed 's/\.$//g')"
        [[ ${DEV_SERVER} ]] || return 1
        printf "%s" "${DEV_SERVER}\n"
    fi 
}
