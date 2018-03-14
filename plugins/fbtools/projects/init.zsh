#! /usr/local/bin/zsh || /usr/bin/zsh

command -v realpath &>/dev/null || return 2
if [[ $0 == /bin/bash ]] ; then
    _fbtools_projects_local_script=${HOME}/.dotfiles/plugins/fbtools/projects
    exec zsh $_fbtools_projects_local_script/init.zsh
else
    _fbtools_projects_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
fi
if ! [[ ${_fbtools_projects_local_script} =~ fbtools ]];then
    _fbtools_projects_local_script=${HOME}/.dotfiles/plugins/fbtools/projects
fi
_tmux_scripts="$(realpath -e ${_fbtools_projects_local_script%/}/../tmux/scripts)"
_tasks_scripts="$(realpath -e ${_fbtools_projects_local_script%/}/../tasks/)"
_fbtools_scripts="$(realpath -e ${_fbtools_projects_local_script%/}/../)"
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"
#

source ${_fbtools_scripts}/utils.zsh || return 10


PROJECT_RX_SIMP='[_A-Za-z0-9]+'
PROJECT_RX='P([0-9]*)\+('${PROJECT_RX_SIMP}')'

[[ ${_FB_TMUX_HELPER_H} ]] || source ${_tmux_scripts}/../init.zsh

: ${PROJECT_ROOT_DIR:="${HOME}/projects"}
export PROJECT_ROOT_DIR
: ${PROJECT_LINK:=${PROJECT_ROOT_DIR}/current}
[[ ${TASK_ROOT_DIR} ]] || source ${_tasks_scripts}/init.zsh
[[ ${TASK_ROOT_DIR} ]] || return 10

function _fb_projects_helper_list_projects () {
    find "${PROJECT_ROOT_DIR}" -maxdepth 1 -mindepth 1 -type d \
        -exec basename {} \; 2>/dev/null | while read file; do
            printf 'P+%s\n' "${file}"
        done 2>/dev/null
}

function _fb_projects_helper_init_projects_here () {
    local CUR_DIR=$(pwd -P)
    local _NEW_TASK _PROJNAME="P+$(basename ${CUR_DIR})"
    _fb_projects_helper_is_valid_project "${_PROJNAME}" || return 3
    [[ -e .envrc && -x "${CUR_DIR}/.venv/${_PROJNAME}/bin/activate" ]] && \
        return 0
    _fb_projects_helper_project_shortname $_PROJNAME | read _b _PROJNAME _a || return $?
    _fb_helper_util_layout_python python3 ${_PROJNAME}
    _fb_helper_util_layout_python python2 ${_PROJNAME}
    sed 's/^    //g' > .envrc << _EOF
    #!/bin/bash
    [[ -d "${CUR_DIR}/.env/venv" ]] || mkdir -p "${CUR_DIR}/.env/venv"
    export VENV_DIR="${CUR_DIR}/.env/venv"
    for _VENV_VERS in \$(find ${CUR_DIR}/.env -ipath /${CUR_DIR#/}/.env/venv/\*/bin/activate ); do
        [[ \${_VENV_VERS} =~ ${CUR_DIR}/.env/venv/([0-9.]*)-${_PROJNAME}/bin/activate ]] && source "\${_VENV_VERS}"
        [[ \${BASH_REMATCH} ]] && echo \${BASH_REMATCH[1]} 
        [[ \${match} ]] && echo \${match[1]}
        break;
    done
_EOF
    (
    cd $(realpath -e "${CUR_DIR}") &>/dev/null
    direnv allow .
    )
}

function _fb_projects_helper_is_valid_project() {
    local _PROJNAME _id _a
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        | read _id _PROJNAME _a || return $?
    if _fb_projects_helper_list_projects | grep -q "^P[+]${_PROJNAME}\$" ; then
        return 0
    fi
    return 1
}

function _fb_projects_helper_cd_to_project_home () {
    local _PROJNAME _id _TASKNAME
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
        | read _id _PROJNAME _TASKNAME || return $?
    local _PROJ_HOME="$(_fb_projects_helper_get_projects_home ${1})"
    [[ ${_PROJ_HOME} ]] || return 2
    if [[ ${_TASKNAME} && -h "${_PROJ_HOME%/}/${_TASKNAME}" ]]; then
        cd "${_PROJ_HOME%/}/${_TASKNAME}"
    else
        cd  "${_PROJ_HOME}"
    fi
}

function _fb_projects_helper_get_projects_home() {
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

#  create project directory
function _fb_projects_helper_get_projects_home() {
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

alias new_project='_fb_projects_helper_get_projects_home'

function _fb_projects_helper_project_shortname() {
    local _PROJNAME=${1#[0-9]*}  _NEW_TASK=$2
    if [[ ${_PROJNAME} =~ ^${TASK_REGEX:-"T(.*)"}$ ]]; then
        _NEW_TASK="T${match[1]}"
        _PROJNAME="$(_fb_tmux_helper_get_session)"
    fi
    echo ${_PROJNAME} >&2
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
    _fb_projects_helper_project_shortname ${_LONGNAME} ${_NEW_TASK} | \
        read _SOMEID _PROJNAME _NEW_TASK
    echo $_SOMEID $_PROJNAME $_NEW_TASK
    [[ ${_PROJNAME} ]] || return 1

    if ! _fb_projects_helper_is_valid_project "P+${_PROJNAME}-${_NEW_TASK}" >/dev/null; then
        return 4
    else
        (
        setopt xtrace
        trap ':' SIGINT
        TASK_REL="../../tasks"
        cd $(_fb_projects_helper_get_projects_home P+${_PROJNAME}) &>/dev/null || exit 1
        # add task link to project
        if ! [[ ${TASK_REL} -ef ${TASK_ROOT_DIR} ]]; then
            # use relative link 
            TASK_REL="${TASK_ROOT_DIR}"
        fi
        # create a link to the new task in the project dir
        ln -s "${TASK_REL}/${_NEW_TASK}" 2>/dev/null
        _TASK_ROOT_DIR=$(realpath -e "${TASK_REL%/}/${_NEW_TASK}")
        # Look for root working dir
        _PROJECT_VCS=$(realpath -e "${PROJECT_ROOT_DIR%/}/${_PROJNAME}")
        # for each <project-dir>/repo-name
        for repo in "${_PROJECT_VCS%/}/${_PROJNAME:l}"-?*; do
            [[ -h ${repo} ]] || continue
            _PROJECT_VCS_ROOT="$(realpath -e "${repo}")"
            while ! [[ -d "${_PROJECT_VCS_ROOT%/}/.hg" ]]; do
                [[ "${_PROJECT_VCS_ROOT}" -ef "${HOME}" || "${_PROJECT_VCS_ROOT}" -ef '/' ]] && exit 5
                _PROJECT_VCS_ROOT=${_PROJECT_VCS_ROOT:h}
            done
            # get the name of the root repo dir
            DIFF_ROOT="${_PROJECT_VCS_ROOT:t}"
            [[ ${DIFF_ROOT} ]] && DIFF_ROOT="-${DIFF_ROOT}"

            # Create new working dir
            _VCS_DEST="${_TASK_ROOT_DIR}/.workdir${DIFF_ROOT}"
            mkdir -p "${_VCS_DEST}"
            _PROJECT_VCS_ROOT="$(realpath -e "${_PROJECT_VCS_ROOT}")"
            # Create a new working direcotry if it doesnt exists
            [[ -e ${_VCS_DEST} && ! -d ${_VCS_DEST}/.hg ]] && (\
                if [[ -x /opt/facebook/hg/bin/hg-new-workdir ]]; then
                    _HG_CLONE=/opt/facebook/hg/bin/hg-new-workdir
                fi
                #echo "HG COMMAND ${_HG_CLONE:-hg-new-workdir}" \
                # "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}"
                ${_HG_CLONE:-hg-new-workdir} "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}" || return 4
            )
            # the relitive localtion in the workin copy of the project link
            DIFF_REPO="$(realpath -e ${repo})"
            DIFF_PATH="${DIFF_REPO##"${_PROJECT_VCS_ROOT}"}"
            # save some metadata for later
            printf 'project.path[%s]=./%s' "${DIFF_ROOT}" "${DIFF_PATH#/}" \
            >> "${_TASK_ROOT_DIR}/.project"
            printf 'project.import=%s' "${DIFF_PATH:gs/\//.}" \
            >> "${_TASK_ROOT_DIR}/.project"
            # Move to the task directory
            pushd "${TASK_ROOT_DIR}/${_NEW_TASK}"
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
                # link to the same rel path as our main link
                ln -s .workdir${DIFF_ROOT} "${DIFF_ROOT#-}"
                ln -s .workdir${DIFF_ROOT}/${DIFF_PATH#/} "${DOT_PATH}"
                ln -s .workdir${DIFF_ROOT}/buck-out/gen/${DIFF_PATH#/} "buck.${DOT_PATH}"
                [[ ${DIFF_ROOT} =~ fbsource ]] || command -v arc >&2 \
                    && (cd "${_VCS_DEST}" &>/dev/null; \
                    hg sparse --enable-profile .hgsparse-fbcode
                if ! hg update ${_NEW_TASK} ; then
                    hg update master && hg book ${_NEW_TASK}
                fi )
            popd
        done

        printf 'project_dir=%s' "$(pwd -P)" \
           >> "${_TASK_ROOT_DIR}/.project"

        unsetopt xtrace
        ) 
        return $?
    fi
}

function _fb_projects_helper_verify_project() {
    local _PROJNAME=${1:-$(_fb_tmux_helper_get_session)}
    (
        cd $(_fb_projects_helper_get_projects_home P+${_PROJNAME}) 1>/dev/null
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

function _fb_projects_helper_add_projects_to_project() {
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
        cd $(_fb_projects_helper_get_projects_home "P+${_PROJNAME}") &>/dev/null || exit 1
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

function _fb_projects_helper_session_task () {
    local _SOMEID _PROJNAME _NEW_TASK
    _fb_projects_helper_project_shortname | read _SOMEID _PROJNAME _NEW_TASK || return 2
    _fb_tasks_helper_set_task $_NEW_TASK || return 3
    _fb_projects_helper_add_task_to_project ${_NEW_TASK} P+${_PROJNAME}
    cd $(_fb_projects_helper_get_projects_home P+${_PROJNAME})/${_NEW_TASK}
}

alias add_task_to_project='_fb_projects_helper_add_task_to_project'
alias get_projects_home='_fb_projects_helper_get_projects_home'
alias session_task_override='_fb_projects_helper_session_task'
alias cd_to_project_home='_fb_projects_helper_cd_to_project_home'
