#! /usr/local/bin/zsh || /usr/bin/zsh

command -v realpath &>/dev/null || return 1

_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
_tmux_scripts="$(realpath -e ${_local_script%/}/../tmux/scripts)"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"

TASK_REGEX=-?T([0-9][0-9]*)$
source ${_tmux_scripts}/../helpers.zsh

: ${TASK_ROOT_DIR:="${HOME}/tasks"}
export TASK_ROOT_DIR
: ${TASK_LINK:=${TASK_ROOT_DIR}/current}

_proj_scripts="$(realpath -e ${_local_script%/}/../projects/init.zsh)"

function _fb_tasks_helper_list_tasks () {
    find "${TASK_ROOT_DIR}" -maxdepth 1 -regex ".*[PT][0-9].*" \
        -exec basename {} \; 2>/dev/null
}

function _fb_tasks_helper_is_valid_task () {
    # TODO: check project
    local _NEW_TASK=${1:-${NEW_TASK}}
    [[ $_NEW_TASK =~ ^${TASK_REGEX}$ ]] || return 1
    _fb_tasks_helper_list_tasks | grep -qi ${_NEW_TASK} &>/dev/null || return 2
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

function _fb_tasks_helper_task_root {
    _NEW_TASK=$(basename ${1:-$(current_task)})
    _fb_tasks_helper_is_valid_task ${_NEW_TASK} || return 1
    realpath -e "${TASK_ROOT_DIR%/}/${_CURRENT_LINK}"
}

function _fb_tasks_helper_set_task () {
    local _NEW_TASK=$(basename $1)
    local _tmux_session=$(_fb_tmux_helper_get_session)
    if [[ ${_NEW_TASK} =~ ${TASK_REGEX} ]]; then
        _NEW_TASK=T${match[1]}
    else
        return 2
    fi
    (
    [[ -h ${TASK_LINK} ]] && rm ${TASK_LINK%/}
    cd "${TASK_ROOT_DIR:="${HOME}/tasks"}" &>/dev/null
    mkdir "${_NEW_TASK}"
    ln -s "$(basename ${_NEW_TASK%%/*})" "${TASK_LINK}"
    ) &>/dev/null || return
    _fb_tasks_helper_change_session_to_cur_task ${_NEW_TASK}
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

function _fb_tasks_helper_change_session_to_cur_task () {
    local _SOMEID _PROJNAME _NEW_TASK
    local _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_projects_helper_project_shortname ${_tmux_session} \
            | read _SOMEID _PROJNAME _OLD_TASK
    _NEW_TASK=$(_fb_tasks_helper_get_current_task)
    _PROJNAME=P+${_PROJNAME:='None'}
    : ${_NEW_TASK:=$(_fb_tasks_helper_get_current_task)}
    if _fb_tasks_helper_is_valid_task ${_NEW_TASK}; then
        if _fb_tmux_helper_session_exists "${_PROJNAME}-${_NEW_TASK#-}"; then
            bash "${_tmux_scripts%/}/switch_or_loop.sh"  "${_PROJNAME}-${_NEW_TASK#-}" || return 128
        else
            bash "${_tmux_scripts%/}/new_session.sh"  "${_PROJNAME}-${_NEW_TASK#-}" || return 129
        fi
    fi
    return 2
}

function _fb_tasks_helper_set_task_from_session_name () {
    local _NEW_TASK _PRJNAME _OTHERID
    local _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_projects_helper_project_shortname ${_tmux_session} \
            | read _SOMEID _PROJNAME _NEW_TASK
    if _fb_tasks_helper_is_valid_task "${_NEW_TASK}" ;then
        _fb_tasks_helper_set_task ${_NEW_TASK} && return
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
alias task_home='[[ -h ${TASK_LINK} ]] && cd $(realpath -e ${TASK_LINK})'
alias task_from_tmux='_fb_tasks_helper_set_task_from_session_name'
alias go_to_task='_fb_tasks_helper_change_session_to_cur_task'
