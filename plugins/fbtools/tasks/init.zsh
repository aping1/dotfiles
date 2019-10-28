# /usr/local/bin/zsh || /usr/bin/zsh

if [[ $0 == /bin/bash ]] ; then
    _fbtools_tasks_local_script=${HOME}/.dotfiles/plugins/fbtools/tasks
    exec zsh $_fbtools_tasks_local_script/init.zsh
else
    _fbtools_tasks_local_script="$( cd $(dirname "${0:A}") &>/dev/null; pwd -P;)"
fi
if ! [[ ${_fbtools_tasks_local_script} =~ fbtools ]]; then
    _fbtools_tasks_local_script=${HOME}/.dotfiles/plugins/fbtools/tasks
fi
_tmux_scripts="${_fbtools_tasks_local_script%/}/../tmux/scripts"
_tmux_scripts="${_tmux_scripts:A}"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"

TASK_REGEX='([A-Z]{0,3})(-?)([0-9][0-9]*)$'
[[ ${_FB_TMUX_HELPER_H} ]] || source ${_tmux_scripts}/../init.zsh

: ${TASK_ROOT_DIR:="${HOME}/tasks"}
export TASK_ROOT_DIR
: ${TASK_LINK:=${TASK_ROOT_DIR}/current}

_proj_scripts="{_fbtools_tasks_local_script%/}/../projects/init.zsh"
_proj_scripts=${_proj_scripts:A}

### START FUNCTIONS =====
#
function _fb_tasks_helper_task_shortname() { local _PROJNAME=${1#[0-9]*}  _NEW_TASK=$2
    if [[ ${_PROJNAME} =~ ^P\+\d*-?${TASK_REGEX:-"([A-Z]{,3})(-?)([[:digit:]]*)"}$ ]]; then
        echo ${match[*]}
        _NEW_TASK="${match[2]}${match[3]}${match[4]}"
    elif [[ ${_PROJNAME} =~ ${TASK_REGEX:-"([A-Z]{,3})(-?)([[:digit:]]*)"}$ ]]; then
        _NEW_TASK="${match[1]}${match[2]}${match[3]}"
    fi
    printf '%s\n' "${_NEW_TASK}"
}

function _fb_tasks_helper_list_tasks () {
    find "${TASK_ROOT_DIR}" -maxdepth 1 -regex ".*${TASK_REGEX}.*" \
        -exec basename {} \; 2>/dev/null
    [[ 1 == 1 ]] && return 0
}

function _fb_tasks_helper_is_valid_task () {
    # TODO: check project
    local _NEW_TASK=${1:-${NEW_TASK}}
    [[ $_NEW_TASK =~ ^${TASK_REGEX}$ ]] || return 1
    _fb_tasks_helper_list_tasks | grep -qi ${_NEW_TASK} &>/dev/null
    return 0
}

function _fb_tasks_helper_is_current_task () {
    local _TASK_ARG=$1
    if _fb_tasks_helper_is_valid_task "${_TASK_ARG}" || return 2; then
        _CURRENT_LINK="$(basename ${TASK_LINK:A})"
        [[ ${_TASK_ARG} == ${_CURRENT_LINK} ]] && return 0
        return 1
    fi
}

function _fb_tasks_helper_task_root {
    _NEW_TASK=${1:-$(current_task)}
    [[  $_NEW_TASK =~ '/' ]] && _NEW_TASK=$(basename ${_NEW_TASK})
    _fb_tasks_helper_is_valid_task ${_NEW_TASK} || return 1
    local task_link="${TASK_ROOT_DIR%/}/${_CURRENT_LINK}"
    echo "${task_link:A}"
}

function _fb_tasks_helper_set_task () {
    local _NEW_TASK
    _fb_tasks_helper_task_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        2> /dev/null | read _NEW_TASK
    if [[ ${_NEW_TASK} ]] ; then 
    (
    cd "${TASK_ROOT_DIR:="${HOME}/tasks"}" >/dev/null
    mkdir "${_NEW_TASK}"
    # [[ -h ${TASK_LINK} ]] && rm ${TASK_LINK%/}
    # ln -s "$(basename ${_NEW_TASK})" "${TASK_LINK}"
    mkdir "${_NEW_TASK}"
    [[ -d "${_NEW_TASK}" ]] || exit 1
    ) >/dev/null && \
    _fb_tasks_helper_change_session_to_cur_task "${1}"
fi 
}

alias set_task='_fb_tasks_helper_set_task'

function _fb_tasks_helper_change_session_to_cur_task () {
    local _SOMEID _PROJNAME _NEW_TASK=${1}
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
            | read _SOMEID _PROJNAME _OLD_TASK || return 2
    [[ ${_SOMEID} == None ]] && _SOMEID=""
    PROJECT_SHIT="P${_SOMEID}+${_PROJNAME}-${_OLD_TASK}"
    if _fb_tmux_helper_session_exists ${PROJECT_SHIT}; then
        bash "${_tmux_scripts%/}/switch_or_loop.sh"  "${PROJECT_SHIT}" || return 128
        return 0
    else
        bash "${_tmux_scripts%/}/new_session.sh"  "${PROJECT_SHIT}" || return 129
        return 0
    fi
    return 2
}

function _fb_tasks_helper_set_task_from_session_name () {
    local _NEW_TASK
    local _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_tasks_helper_task_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        2> /dev/null | read _NEW_TASK
    if [[ ${_NEW_TASK} ]] ; then 
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

function task_from_tmux() {
    local _TASK
    local _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_tasks_helper_task_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        2> /dev/null | read _TASK
    printf "%s" "${_TASK}"
}


alias task_list='_fb_tasks_helper_list_tasks'
alias cur_task='_fb_tasks_helper_get_current_task'
alias task_home='printf "%s\n" "${TASK_ROOT_DIR:="${HOME}/tasks"}/$(task_from_tmux)"'
alias cd_task_home='cd "${TASK_ROOT_DIR:="${HOME}/tasks"}/$(task_from_tmux)"'
alias cdtask='cd_task_home'

alias set_task_from_session='_fb_tasks_helper_set_task_from_session_name'
alias goto_task_session='_fb_tasks_helper_change_session_to_cur_task'

function _fb_tasks_local_kube () {
    if [[ -d "${TASK_ROOT_DIR:-"${HOME}/tasks"}/$(task_from_tmux)/" ]]; then
        export KUBECONFIG="${TASK_ROOT_DIR:-"${HOME}/tasks"}/$(task_from_tmux)/.kube_config"
    fi
}

# if [[ ${TMUX} && precmd_functions[(r)_fb_tasks_local_kube == _fb_tasks_local_kube ]]; then
#     precmd_functions[(r)_fb_tasks_local_kube]+=(_fb_tasks_local_kube)
# fi

