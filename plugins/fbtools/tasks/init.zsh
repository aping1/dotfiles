_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"

_tmux_scripts="$(realpath -e ${_local_script%/}/../tmux/scripts)"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"

source ${_tmux_scripts}/../helpers.zsh

: ${TASK_DIR:="${HOME}/tasks"}
export TASK_DIR
: ${TASK_LINK:=${TASK_DIR}/current}

function list_tasks () {
    find "${TASK_DIR}" -maxdepth 1 -regex ".*[PT][0-9].*" \
        -exec basename {} \; 2>/dev/null
}

function is_valid_task () {
    [[ ${1:-${NEW_TASK}} =~ [PT][0-9][0-9]* ]] || return 1
    list_tasks | grep -qi ${1:-${NEW_TASK}} &>/dev/null || return 1
}


function current_task () {
    if ! [[ -h ${TASK_LINK} ]] ; then
        printf 'ERROR: No current task link is set\n' 
        return 1
    fi
    echo "${_CURRENT_LINK:="$(basename $(realpath -e ${TASK_LINK}))"}"
}

function set_task () {
    is_valid_task ${_NEW_TASK:=$(basename $1)} || return 1
    [[ -h ${TASK_LINK} ]] && rm ${TASK_LINK%/}
    # list_tasks | grep -qi "${_NEW_TASK}" || echo "Creating task ${_NEW_TASK}" 
    ( 
    cd "${TASK_DIR}" &>/dev/null
    mkdir "${_NEW_TASK}" 
    set_tmux_session_to_task 
    ln -s "$(basename ${_NEW_TASK%%/*})" "${TASK_LINK}" 
    ) &>/dev/null
    return $?
}


if [[ -h ${TASK_LINK} ]] ; then
   _CURRENT_TASK_LINK="$(basename $(realpath -e ${TASK_LINK}))"
elif [[ -e ${TASK_LINK} ]] ; then
    printf 'ERROR: current is not link\n' >&2
    return 1
else
    #TODO: Choose task
    printf 'INFO: no current task set\n' >&2
fi

function set_tmux_session_to_task () {
    _tmux_session="$(_fb_tmux_helper_get_session)"
    [[ ${_tmux_session} =~ ^[PT][0-9][0-9]* ]] && return 0
    if is_valid_task ${_NEW_TASK:=$(basename $1)}; then
        if _fb_tmux_helper_session_exists "${_NEW_TASK}"; then
            bash "${_tmux_scripts%/}/switch_or_loop.sh"  "${_NEW_TASK}" || return 128
        else
            bash "${_tmux_scripts%/}/new_session.sh"  "${_NEW_TASK}" || return 129
        fi
    fi
    return 2
}

function set_task_description() {
    _NEW_TASK=$(basename ${1:-$(current_task)})
    if is_valid_task "${_NEW_TASK}"; then
        DESC_FILE="${TASK_DIR%/}/${_NEW_TASK%/}/.desc"
        touch  ${DESC_FILE}
        use_editor  ${DESC_FILE}
    fi
}

