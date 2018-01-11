command -v realpath &>/dev/null || return 1
_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"

_tmux_scripts="$(realpath -e ${_local_script%/}/../tmux/scripts)"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"

source ${_tmux_scripts}/../helpers.zsh

: ${TASK_ROOT_DIR:="${HOME}/tasks"}
export TASK_ROOT_DIR
: ${TASK_LINK:=${TASK_ROOT_DIR}/current}

function _fb_tasks_helper_list_tasks () {
    find "${TASK_ROOT_DIR}" -maxdepth 1 -regex ".*[PT][0-9].*" \
        -exec basename {} \; 2>/dev/null
}


function _fb_tasks_helper_is_valid_task () {
    [[ ${1:-${NEW_TASK}} =~ ^[PT][0-9][0-9]* ]] || return 1
    _fb_tasks_helper_list_tasks | grep -qi ${1:-${NEW_TASK}} &>/dev/null || return 2
}

function _fb_tasks_helper_is_current_task () {
    local _TASK_ARG=$1
    if {_fb_tasks_helper_is_valid_task "${_TASK_ARG}" || return 2;} then
        _CURRENT_LINK="$(basename $(realpath -e ${TASK_LINK}))"
        [[ ${_TASK_ARG} == ${_CURRENT_LINK} ]] && return 0
        return 1
    fi
}

function _fb_tasks_helper_get_current_task () {
    local _CURRENT_LINK
    local _RET
    if ! [[ -h ${TASK_LINK} ]] ; then
        printf 'ERROR: No current task link is set\n' 
        return 1
    fi
    _CURRENT_LINK="$(basename $(realpath -e ${TASK_LINK}))"
    # IF the task is not rvalid but ret is 1
    export TASK_HOME="${TASK_ROOT_DIR%/}/${_CURRENT_LINK}"
    if ! _fb_tasks_helper_is_valid_task "${_CURRENT_LINK}" && [[ ${_RET:=$?} == 1 ]] ; then
        # Abort with non valid task
        printf 'ERROR: current task link not set to task\n'
        return 2
    elif  [[ ! -d ${TASK_HOME} ]] && [[ ${_RET} == 2 ]]; then
        mkdir -p "${TASK_HOME}"
    fi
    echo "${_CURRENT_LINK}"

}

function _fb_tasks_helper_set_task () {
    export _NEW_TASK=$(basename $1)
    _fb_tasks_helper_is_current_task ${_NEW_TASK} && return 0
    _fb_tasks_helper_is_valid_task ${_NEW_TASK} || return 1
    [[ -h ${TASK_LINK} ]] && rm ${TASK_LINK%/}
    # _fb_tasks_helper_list_tasks | grep -qi "${_NEW_TASK}" || echo "Creating task ${_NEW_TASK}" 
    (
    cd "${TASK_ROOT_DIR:="${HOME}/tasks"}" &>/dev/null
    mkdir "${_NEW_TASK}" 
    ln -s "$(basename ${_NEW_TASK%%/*})" "${TASK_LINK}" 
    _fb_tasks_helper_set_task_to_session ${1}
    ) &>/dev/null
    return $?
}

alias set_task='_fb_tasks_helper_set_task'

if [[ -h ${TASK_LINK} ]] ; then
   _CURRENT_TASK_LINK="$(basename $(realpath -e ${TASK_LINK}))"
elif [[ -e ${TASK_LINK} ]] ; then
    printf 'ERROR: current is not link\n' >&2
    return 1
else
    #TODO: Choose task
    printf 'INFO: no current task set\n' >&2
fi

function _fb_tasks_helper_set_task_to_session () {
    local _NEW_TASK="$(basename ${1})"
    _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_tasks_helper_is_valid_task "${_tmux_session}" || return 1
    if _fb_tasks_helper_is_valid_task ${_NEW_TASK}; then
        if _fb_tmux_helper_session_exists "${_NEW_TASK}"; then
            bash "${_tmux_scripts%/}/switch_or_loop.sh"  "${_NEW_TASK}" || return 128
        else
            bash "${_tmux_scripts%/}/new_session.sh"  "${_NEW_TASK}" || return 129
        fi
    fi
    return 2
}

function go_to_current_task () {
    _fb_tasks_helper_set_task_to_session "$(_fb_tasks_helper_get_current_task)"
}

function _fb_tasks_helper_set_task_from_tmux () {
    _tmux_session="$(_fb_tmux_helper_get_session)"
    if _fb_tasks_helper_is_valid_task "${_tmux_session}" ;then
        _fb_tasks_helper_set_task ${_tmux_session} && return
    fi
    return 1
}

function _fb_tasks_helper_set_task_description() {
    # TODO: Dev me. dont think this works
    _NEW_TASK=$(basename ${1:-$(current_task)})
    if _fb_tasks_helper_is_valid_task "${_NEW_TASK}"; then
        DESC_FILE="${TASK_DIR%/}/${_NEW_TASK%/}/.desc"
        touch  ${DESC_FILE}
        use_editor  ${DESC_FILE}
    fi
}

alias task_list='_fb_tasks_helper_list_tasks'
alias cur_task='_fb_tasks_helper_get_current_task'
alias task_home='cd $(realpath -e ${TASK_LINK})'
