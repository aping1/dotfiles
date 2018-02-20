
SSH_SOCKETS_DIR=${HOME}/.ssh/sockets/
mkdir -p ${HOME}/.ssh/sockets/

which git &>/dev/null || return 1

## todo add sentinal
## git clone tpm
#mkdir -p ~/.tmux/plugins
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#
## clone
#mkdir -p .vim/bundle
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#
#vim -es << _EOF
# Bundlinstall
#_EOF

usage () {
    printf "Usage: boostrap.sh HOST\n"
    printf "-h  print usage\n"
}



SSH_HOST=${1}
[[ ${SSH_HOST} ]] || return 2

ssh_cleanup_master() {
    for socket in ${SSH_SOCKETS_DIR}; do
        ssh -o ControlPath=$socket -O check
    done
}

ssh_control_persist () {
    SSH_HOST=${1}
    [[ ${SSH_HOST} ]] || return 1
    ssh -oControlMaser=auto -oPersistConnect=10s -oControlPath="${TEMP_SOCK}" \
        "${SSH_HOST}"
}

get_platfrom_files () {
    local _REMOTE_PLATFORM_FILES="${REMOTE_PLATFORM_FILES}"
    local _TEMP_FILE=$(mktemp /tmp/.remote_files.XXXXX)
    exec 6> "${_TEMP_FILE}"
    for POSIXFILE in ${REMOTE_POSIX_FILES}; do
        if [[ ! ${_REMOTE_PLATFORM_FILES} =~ $(basename "${POSIXFILE}") ]]; then
            printf '%s' ${POSIXFILE}
        fi
    done
    echo "${_REMOTE_PLATFORM_FILES}"
    echo ${_TEMP_FILE}
}

: ${PLATFORM:=POSIX}

REMOTE_POSIX_FILES="$(find ${DOTFILES:="$HOME/.dotfiles/remote"} -maxdepth 1 -iname '.*')"
REMOTE_PLATFORM_FILES="$(find "${DOTFILES%/}/${PLATFORM:=POSIX}" -iname '.*' 2>/dev/null)"

if [[ ${PLATFORM} && ${SSH_HOST} ]]; then
    rsync -avLz -e "ssh -OControlPath=${TEMP_SOCK}" --from-file ${TEMP_FILE:=$(get_platfrom_files)} ${SSH_HOST}
elif [[ ${PLATFORM} =~ ^Darwing ]]; then
elif [[ ${PLATFORM} =~ ^Linux ]]; then
fi
