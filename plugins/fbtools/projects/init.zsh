#! /usr/local/bin/zsh || /usr/bin/zsh

command -v realpath &>/dev/null || return 2
_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
_tmux_scripts="$(realpath -e ${_local_script%/}/../tmux/scripts)"
_tasks_scripts="$(realpath -e ${_local_script%/}/../tasks/)"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"
#


PROJECT_RX_SIMP='[_A-Za-z0-9]+'
PROJECT_RX='P([0-9]*)\+('${PROJECT_RX_SIMP}')'

source ${_tmux_scripts}/../helpers.zsh

: ${PROJECT_ROOT_DIR:="${HOME}/projects"}
export PROJECT_ROOT_DIR
: ${PROJECT_LINK:=${PROJECT_ROOT_DIR}/current}
[[ ${TASK_ROOT_DIR} ]] || source ${_tasks_scripts}/init.zsh

function _fb_projects_helper_list_projects () {
    find "${PROJECT_ROOT_DIR}" -maxdepth 1 -mindepth 1 -type d \
        -exec basename {} \; | while read file; do
            printf 'P+%s\n' "${file}"
        done 2>/dev/null
}

function _fb_projects_helper_is_valid_project() {
    local _PROJNAME _id _a
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        | read _b _PROJNAME _a || return $?
    if _fb_projects_helper_list_projects | grep -q "^P[+]${_PROJNAME}\$" ; then
        return 0
    fi
    return 1
}

#  create project directory
function _fb_projects_helper_get_project_home() {
    local _RET=""
    local _SOMEID _PROJNAME _NEW_TASK
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        | read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 4
    if ! _fb_projects_helper_is_valid_project ${_PROJNAME} ; then
        [[ ${_RET:=$?} == 2 ]] && return 2
        mkdir -p "${HOME}/projects/${_PROJNAME}"
    fi
    realpath -e "${PROJECT_ROOT_DIR%/}/${_PROJNAME}"
}

function _fb_projects_helper_project_shortname() {
    local _PROJNAME=$1 _NEW_TASK=$2
    if [[ ${_PROJNAME} =~ ^${TASK_REGEX:-"T(.*)"}$ ]]; then
        _NEW_TASK="T${match[1]}"
        _PROJNAME="$(_fb_tmux_helper_get_session)"
    fi
    if ! [[ ${_PROJNAME} =~ ^${PROJECT_RX}[-]? ]] ; then
        return 1
    elif [[ ${_PROJNAME} =~ ^${PROJECT_RX}${TASK_REGEX:-"(.*)"} ]]; then
        _NEW_TASK="${_NEW_TASK:-$match[3]}"
        _NEW_TASK="T${_NEW_TASK#T}"
    fi
    _PROJNAME=$match[2]
    _SOMEID=${_SOMEID:-$match[1]}
    printf '%s %s %s\n' "${_SOMEID:-"None"}" "${_PROJNAME:-"None"}" "${_NEW_TASK}"
}

function _fb_projects_helper_add_task_to_project() {
    local  _SOMEID _NEW_TASK=$1
    local _PROJNAME _LONGNAME=${2:-$(_fb_tmux_helper_get_session)} 
    _fb_projects_helper_project_shortname ${_LONGNAME} ${_NEW_TASK} \
            | read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 1

    if ! _fb_projects_helper_is_valid_project "P+${_PROJNAME}-${_NEW_TASK}" >/dev/null; then
        return 4
    else
        (
        trap ':' SIGINT
        TASK_REL="../../tasks"
        cd $(_fb_projects_helper_get_project_home P+${_PROJNAME}) &>/dev/null || exit 1
        # add task link to project
        if [[ ${TASK_REL} -ef ${TASK_ROOT_DIR} ]]; then
            ln -s "${TASK_REL}/${_NEW_TASK}" 2>/dev/null
        else
            ln -s "${TASK_ROOT_DIR}/${_NEW_TASK}" 2>/dev/null
        fi
        _TASK_ROOT_DIR=$(realpath -e "${_NEW_TASK}")
        # Look for root working dir
        _PROJECT_VCS=$(realpath -e "${PROJECT_ROOT_DIR%/}/${_PROJNAME%/}/${_PROJNAME:l}")
        _PROJECT_VCS_ROOT="${_PROJECT_VCS}"
        while ! [[ -d "${_PROJECT_VCS_ROOT%/}/.hg" ]] do
            [[ "${_PROJECT_VCS_ROOT}" -ef "${HOME}" || "${_PROJECT_VCS_ROOT}" -ef '/' ]] && return 5
            _PROJECT_VCS_ROOT=${_PROJECT_VCS_ROOT:h}
        done
        # Create new working dir
        _VCS_DEST="${_TASK_ROOT_DIR}/.workdir"
        mkdir -p "${_VCS_DEST}"
        _PROJECT_VCS_ROOT="$(realpath -e "${_PROJECT_VCS_ROOT}")"
        # Create a new working direcotry if it doesnt exists
        [[ -e ${_VCS_DEST} && ! -d ${_VCS_DEST}/.hg ]] && (\
            /opt/facebook/hg/bin/hg-new-workdir \
                "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}"
            )
        # the rel localtion in the workin copy
        DIFF_PATH="${_PROJECT_VCS##"${_PROJECT_VCS_ROOT}"}"
        printf 'project.path=./%s' "${DIFF_PATH#/}" \
           >> "${_TASK_ROOT_DIR}/.project"
        printf 'project.import=%s' "${DIFF_PATH:gs/\//.}" \
           >> "${_TASK_ROOT_DIR}/.project"
        # TODO: link the project directory in the work directory
        pushd ${_VCS_DEST:h}
            # Create a link to the same rel path as the original
            DOT_PATH=${DIFF_PATH:gs/\//.}
            DOT_PATH=${DOT_PATH#.}
            if [[ -h ${DOT_PATH} ]] ; then
               printf "WARN: diff path \"%s\" exists; deleting link\n" ${DOT_PATH} >&2
               rm ${DOT_PATH}
            elif [[ -e ${DOT_PATH} ]] ; then
               printf "ERROR: diff path \"%s\" exists and is not a link\n" ${DOT_PATH} >&2
               return 2
            fi
            ln -s workdir/${DIFF_PATH#/} "${DOT_PATH}"
            command -v arc >&2 && (cd "${_VCS_DEST}" &>/dev/null; \
                if ! hg update ${_NEW_TASK} ; then
                    hg update master && hg book ${_NEW_TASK}
                fi )
        popd

        printf 'project_dir=%s' "$(pwd -P)" \
           >> "${_TASK_ROOT_DIR}/.project"
        )
        return $?
    fi
}

function _fb_projects_helper_verify_project() {
    local _PROJNAME=${1:-$(_fb_tmux_helper_get_session)}
    (
        cd $(_fb_projects_helper_get_project_home ${_PROJNAME}) 1>/dev/null
        while read line; do
            _PARAM="" _VAL=""
            if [[ line =~ ^([A-Za-z_][A-Za-z0-9]*)=(.*)#?$ ]]; then
                _VAL=match[2]
                case ${_PARAM:=match[1]} in
                    "project_dir")
                        _fb_projects_helper_is_valid_project ${_PARAM} \
                            || return 4
                        ;;
                    "subproject")
                        _fb_projects_helper_is_valid_project ${_PARAM} \
                            || return 4
                        ;;
                    *)
                    logger -s -P error "Unknown line parsed"
                    ;;
                esac
            elif [[ line =~ ^\s*# ]]; then
                continue
            else
                logger -s -P error "Unknown line parsed"
            fi
        done < .project
    )
}

function _fb_projects_helper_add_project_to_project() {
    local  _SOMEID _NEW_TASK=$1
    local _PROJNAME _LONGNAME=${2:-$(_fb_tmux_helper_get_session)} \
    _fb_projects_helper_project_shortname ${_LONGNAME} ${_NEW_TASK} \
            | read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 1
    if ! _fb_tasks_helper_is_valid_project  ${_NEW_TASK} ; then
        return 5
    elif ! _fb_projects_helper_is_valid_project ${_LONGNAME} >/dev/null; then
        return 4
    else
        (
        TASK_REL="../projects"
        cd $(_fb_projects_helper_get_project_home "P+${_PROJNAME}") &>/dev/null || exit 1
        if [[ ${TASK_REL} -ef ${PROJECT_ROOT_DIR} ]]; then
            ln -s "${TASK_REL}/${_NEW_TASK}" 2>/dev/null
        else
            ln -s "${PROJECT_ROOT_DIR}/${_NEW_TASK}" 2>/dev/null
        fi
        printf 'Subproject=%s' "$(pwd -P)" \
            >> "${TASK_ROOT_DIR}/${_NEW_TASK%/}/.project"
        )
        return $?
    fi
}

alias add_task_to_project='_fb_projects_helper_add_task_to_project'
alias get_project_home='_fb_projects_helper_get_project_home'
alias go_home='cd $(get_project_home)'

