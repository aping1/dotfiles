#!/usr/bin/env zsh
#
#
#
if [[ $0 == /bin/bash ]] ; then
    _remote_local_script=${HOME}/.dotfiles/plugins/remote
    exec zsh $_remote_local_script/init.zsh
else
    _remote_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
fi
source "${_remote_local_script}/utils.zsh"

plugins=( $(find "${_remote_local_script}"  -mindepth 2 -name "init.zsh" 2>/dev/null ) )
for PLUGIN_FILE in ${plugins[@]}; do
    #printf "Sourcing ${PLUGIN_FILE}..."
    source "${PLUGIN_FILE}"
done

REMOTE_DIR=${DOTFILES:="${HOME}/.dotfiles"}/remote
REMOTE_PLATFORM_FILES="$(find "${DOTFILES%/}/${PLATFORM:=POSIX}" -iname '.*' 2>/dev/null)"

function _remote_ssh_control_persist () {
    local TEMPDIR=$(mktemp "${TEMP_SOCK:=${HOME}/.ssh/sockets/XXXXXX.sock}")
    local SSH_HOST=${1}
    [[ ${SSH_HOST} ]] || return 1
    mkdir -p ~/.ssh/sockets
    ssh -oControlMaser=auto \
        -oPersistConnect=10s \
        -oControlPath="${TEMP_SOCK:-${HOME}/.ssh/sockets/XXXXXX.sock}" \
        "${SSH_HOST}"
}
function _remote_get_host_platform () {
    local REMOTE_DIR=${1}

}

function sync_files () {
    local REMOTE_HOST=$1
    [[ ${REMOTE_HOST} ]] || { echo "Failed"; return 2; }
    PLATFORM=$(_remote_get_host_platform "${REMOTE_HOST}")
    _remote_get_platfrom_files POSIX | rsync -avP --files-from=- "${DOTFILES}" "${RSYNC_HOST}:"
    _remote_get_platfrom_files ${PLATFORM} | rsync -avP --files-from=- "${DOTFILES}" "${RSYNC_HOST}:"
}

function _remote_get_platfrom_files () {
    local _PLATFORM=${1:-POSIX}
    local PLATFORM_FOLDER="${REMOTE_DIR%/}/${_PLATFORM}/"
    [[ -d ${PLATFORM_FOLDER} ]] || return 2
    find "${PLATFORM_FOLDER%/}" -iname '.*' 2>/dev/null
}

: ${PLATFORM:=POSIX}

# TODO: Sync dotfiles from platform/posix
# TODO: 
