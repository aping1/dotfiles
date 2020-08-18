#! /usr/bin/bash
#! /usr/local/bin/zsh || /usr/bin/zsh
if [[ $0 == /bin/bash ]]; then
    _fbtools_projects_local_script=${HOME}/.dotfiles/plugins/fbtools/projects
    exec zsh $_fbtools_projects_local_script/init.zsh
else
    _fbtools_projects_local_script=$(0:A:h)
fi
if ! [[ ${_fbtools_projects_local_script} =~ fbtools ]];then
    _fbtools_projects_local_script=${HOME}/.dotfiles/plugins/fbtools/projects
fi
_tmux_scripts=${${:-"${_fbtools_projects_local_script%/}/../tmux/scripts"}:A}
_tasks_scripts=${${:-"${_fbtools_projects_local_script%/}/../tasks/"}:A}
_fbtools_scripts=${${:-"${_fbtools_projects_local_script%/}/../"}:A}
# dep ${_tmux_scripts}/new_session.sh "${_NEW_TASK}"

source ${_fbtools_scripts:-"$_fbtools_projects_local_script"}/utils.zsh 


PROJECT_RX_SIMP='[_A-Za-z0-9]+'
PROJECT_RX='\d*P([0-9]*)\+('${PROJECT_RX_SIMP}')'

(( +_FB_TMUX_HELPER_H )) || source ${_tmux_scripts}/../init.zsh &&  export _FB_TMUX_HELPER_H=""

: ${PROJECT_FOLDER_NAME:="projects"}
: ${PROJECT_PREFIX:="${HOME}/${PROJECT_FOLDER_NAME}"}
if ! [[ -d  ${PROJECT_ROOT_DIR:=${PROJECT_PREFIX:A}} ]]; then
    return 1 
fi
export PROJECT_ROOT_DIR
: ${PROJECT_LINK:=${PROJECT_ROOT_DIR}/current}
[[ ${TASK_ROOT_DIR} ]] || source ${_tasks_scripts}/init.zsh
[[ ${TASK_ROOT_DIR} ]] || { printf "Failed Task root %s" "${TASK_ROOT_DIR}"; return 10 };

function _fb_projects_helper_list_projects () {
    find "${PROJECT_ROOT_DIR}" -maxdepth 1 -mindepth 1 -type d \
        -exec basename {} \; 2>/dev/null | while read file; do
            printf -- 'P+%s\n' "${file}"
        done 2>/dev/null
}

function _fb_projects_helper_init_projects_here () {
    local _NEW_TASK _PROJNAME="P+${CUR_DIR:t}"
    _fb_projects_helper_is_valid_project "${_PROJNAME}" || return 3
    [[ -e .envrc && -x "${CUR_DIR:A}/.venv/${_PROJNAME}/bin/activate" ]] && \
        return 0
    _fb_projects_helper_project_shortname $_PROJNAME 2>/dev/null | read _b _PROJNAME _a || return $?
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
}

function _fb_projects_helper_is_valid_project() {
    local _PROJNAME _id _a
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} 2>/dev/null \
        | read _id _PROJNAME _a || return $?
    if _fb_projects_helper_list_projects | grep -q "^P[+]${_PROJNAME}\$" ; then
        return 0
    fi
    return 1
}

function _fb_projects_helper_project_task_home () {
    local _PROJNAME _id _TASKNAME
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
2>/dev/null | read _id _PROJNAME _TASKNAME &>/dev/null || return $?
    local _PROJ_HOME="$(_fb_projects_helper_get_projects_home ${1} 2>/dev/null)"
    [[ ${_PROJ_HOME} ]] || return 2
    if [[ ${_TASKNAME} && -h "${_PROJ_HOME%/}/${_TASKNAME}" ]]; then
        printf '%s/%s' "${_PROJ_HOME%/}" "${_TASKNAME}" 
    else
        printf '%s' "${_PROJ_HOME%/}"
    fi
}

function _fb_projects_helper_get_projects_home() {
    local _RET=""
    local _SOMEID _PROJNAME _NEW_TASK
    _fb_projects_helper_project_shortname ${1:-$(_fb_tmux_helper_get_session)} \
         2>/dev/null | read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 4
    if ! _fb_projects_helper_is_valid_project ${_PROJNAME} ; then
        [[ ${_RET:=$?} == 2 ]] && return 2
        mkdir -p "${HOME}/projects/${_PROJNAME}"
    fi
    printf -- '%s\n' ${${:-"${PROJECT_ROOT_DIR%/}/${_PROJNAME}"}:A}
}


function _fb_projects_helper_project_shortname() {
    local _FULL_NAME="${1}" _NEW_TASK="${2}" _PROJNAME=""
    # the case where ends with a task
    if [[ ${_FULL_NAME} =~ ^${TASK_REGEX:-"(\w)-?(\d+)$"} ]]; then
        # is this inheritance? |_//// 0^0
        _NEW_TASK="${_NEW_TASK:-"$(_fb_tasks_helper_task_shortname $*)"}"
        _PROJNAME="$(_fb_tmux_helper_get_session)"
    fi
    # does the input have a project prefix? does the session name?
    if [[ ${_FULL_NAME} =~ ${PROJECT_RX}-? ]] ; then
        _PROJNAME=${match[2]}
    elif [[ ${_PROJNAME} && ${_PROJNAME} =~ ${PROJECT_RX}-? ]] ; then
        _PROJNAME=${match[2]}
    else 
        # doesnt contain a project
        return 1
    fi
    if [[ ${_PROJNAME} && ${_NEW_TASK} =~ ${TASK_REGEX:-"(\w)(-?)(\d+)\$"} ]]; then
        :
    elif [[ ${_FULL_NAME} =~ ${PROJECT_RX}-${TASK_REGEX:-"(\w)(-?)(\d+)"} ]]; then
        _NEW_TASK="${_NEW_TASK:-"${match[3]}${match[4]}${match[5]}"}"
        _SOMEID=${_SOMEID:-$match[1]}
    else
        return 1
    fi
    printf -- '%s %s %s\n' "${_SOMEID:-"None"}" "${_PROJNAME:-"None"}" "${_NEW_TASK}"
}
function _fb_projects_helper_clone_git() {
    local _PROJECT_VCS_ROOT=$1
    local _VCS_DEST=$2 # Location to clone
    local _GIT_CLONE='cp -rp '  # how to clone
    TIMEOUT="timeout 300"
    printf '[INFO] Command to run: %s\n' "${TIMEOUT} ${_HG_CLONE:-echo} ${_PROJECT_VCS_ROOT} ${_VCS_DEST}" >&2
    if [[ ${DRY_RUN} =~ ^[Yy](es$|$) ]]; then
        TIMEOUT=': '
    fi
    # clone into projects
    eval ${TIMEOUT} ${_GIT_CLONE} \
        "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}" || return 4
}

function _fb_projects_helper_clone_hg() {
    local _PROJECT_VCS_ROOT=$1
    local _VCS_DEST=$2 # Location to clone
    local _HG_CLONE='hg clone'  # how to clone
    local TIMEOUT="timeout 300" # Timeout for 5 min

    if ! [[ -d ${_VCS_DEST} ]] ; then
        if [[ -e ${_VCS_DEST}/.hg ]]; then
            mkdir -p "${_VCS_DEST}"
            _PROJECT_VCS_ROOT="${${:-"${_PROJECT_VCS_ROOT}"}:A}"
            # Create a new working direcotry if it doesnt exists
            [[ -e ${_VCS_DEST} && ! -d ${_VCS_DEST}/.hg ]] && (\
            printf '\n### CLONING HG DIR %s -> %s ###\n' \
                "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}" >&2
            # set eden or hg-new-workdir
            if [[ -x /usr/local/bin/eden ]]; then
                _HG_CLONE="/usr/local/bin/eden clone"
            elif [[ -x /opt/facebook/hg/bin/hg-new-workdir ]]; then
                _HG_CLONE=/opt/facebook/hg/bin/hg-new-workdir
            fi
            printf '[INFO] Command to run: %s\n' "${TIMEOUT} ${_HG_CLONE:-echo} ${_PROJECT_VCS_ROOT} ${_VCS_DEST}" >&2
            if ! [[ ${DRY_RUN} =~ ^[Yy](es$|$) ]]; then
                # clone into projects
                eval ${TIMEOUT} ${_HG_CLONE:-hg-new-workdir} \
                    "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}" || return 4
            fi
        )
        fi 
    fi

    # make it sparse
    printf '[INFO] Found REPO %s\n' "${REPO_NAME#-}" >&2
if [[ ${_NOT_UPDATE} && ${_HG_PROFILE} ]] && command -v arc >&2; then
    (
    cd "${_VCS_DEST}" &>/dev/null
    hg sparse --enable-profile ${_HG_PROFILE:-$3}
    if ! hg update ${_NEW_TASK} ; then
        printf '[INFO] Updating to master at %s\n' "${_VCS_DEST}" >&2
        hg update master && hg book ${_NEW_TASK}
    fi
    ) 1>/dev/null &
fi
}

function _fb_projects_helper_clone_project_task() {
    if [[ ${DRYRUN} || ${DRY_RUN} =~ ^[Yy](es$|$) ]]; then
        export DEBUG=Y
        alias ln='echo'
    fi
    if [[ ${DEBUG} =~ ^[Yy](es$|$) ]]; then
        setopt xtrace
        trap 'unsetopt xtrace' EXIT SIGTERM SIGHUP
    fi
    local  _SOMEID _NEW_TASK=$1
    local _PROJNAME _LONGNAME=${2:-$(_fb_tmux_helper_get_session)}
    _fb_projects_helper_project_shortname ${_LONGNAME} ${_NEW_TASK} 2>/dev/null | \
        read _SOMEID _PROJNAME _NEW_TASK
    printf 'Adding %s to project %s (id %s)\n' "$_NEW_TASK" "$_PROJNAME" "$_SOMEID"
    [[ ${_PROJNAME} ]] || return 1
    if _fb_projects_helper_is_valid_project "P+${_PROJNAME}-${_NEW_TASK}" >/dev/null; then
        (
        [[ ${DRY_RUN} =~ ^[Yy](es$|$) ]] && alias ln='echo'
        if [[ ${DEBUG} =~ ^[Yy](es$|$) ]]; then
            setopt xtrace
            trap 'unsetopt xtrace' EXIT SIGTERM SIGHUP
        fi
        TASK_REL="../../tasks"
        # add task link to project
        if ! [[ ${TASK_REL} -ef ${TASK_ROOT_DIR} ]]; then
            # use relative link
            TASK_REL="${TASK_ROOT_DIR}"
            TASK_ABS="${TASK_ROOT_DIR:A}"
        fi
        # go to project home based on the project name
        # cd $(_fb_projects_helper_get_projects_home "P+${_PROJNAME}") &>/dev/null || exit 1
        _TASK_ROOT_DIR=${${:-"${TASK_REL%/}/${_NEW_TASK}"}:A}
        [[ ${_TASK_ROOT_DIR} ]] && \
            printf 'task.root[%s]=exists\n' "${PWD:A}/${TASK_REL%/}${_NEW_TASK}" >>"${_TASK_ROOT_DIR}/.project" \
            || mkdir -p ${_TASK_ROOT_DIR:=${TASK_REL%/}/${_NEW_TASK}}

        # setopt xtrace
        # create a link to the new task in the project dir
        # create a link to the task in the tasks directory
        [[ -h ${_NEW_TASK} ]] || ln -s "${TASK_REL}/${_NEW_TASK}" &>/dev/null || echo "Failed to link task" >&2
        # Look for root working dir for the project
        _PROJECT_VCS=${${:-"${PROJECT_ROOT_DIR%/}/${_PROJNAME}"}:A}
        # for each <project-dir>/repo-name
        # for each link that starts with $_PROJNAME
        printf ';[%s]\n' "$(date -u)" >>"${_TASK_ROOT_DIR}/.project"
        printf 'project_dir=%s\n' ${PWD:A} >>"${_TASK_ROOT_DIR}/.project"
        # for each bookmark or repo
        for repo_or_link in "${_PROJECT_VCS%/}/${_PROJNAME:l}"-?*; do
            [[ -h ${repo_or_link} ]] || continue
            ## The repo root, find it
            #======== repo root path
            REPO_LINK_PATH="${repo_or_link:A}"
            _PROJECT_VCS_ROOT="${REPO_LINK_PATH}"
            while ! [[ -d "${_PROJECT_VCS_ROOT%/}/.hg" && ! -d "${_PROJECT_VCS_ROOT%/}/.git" ]]; do

                [[ "${_PROJECT_VCS_ROOT}" -ef "${HOME}" || "${_PROJECT_VCS_ROOT}" -ef '/' ]] && exit 5
                _PROJECT_VCS_ROOT=${_PROJECT_VCS_ROOT:h}
            done
            # get the name of the root repo dir containing .hg or .git
            REPO_NAME="${_PROJECT_VCS_ROOT:t}"
            [[ ${REPO_NAME} ]] && REPO_NAME="-${REPO_NAME}"
            _VCS_DEST="${_TASK_ROOT_DIR}/.workdir${REPO_NAME}"
            [[ -d "${_PROJECT_VCS_ROOT%/}/.git" ]] && _fb_projects_helper_clone_git "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}"
            [[ -d "${_PROJECT_VCS_ROOT%/}/.hg" ]] && _fb_projects_helper_clone_hg "${_PROJECT_VCS_ROOT}" "${_VCS_DEST}"
            #======== 
            
            #======== create a bookmark for that directory relativvely
            # the relitive localtion in the workin copy of the project link
            declare -a DIFF_PATH=("${(s./.)REPO_LINK_PATH##${_PROJECT_VCS_ROOT}}")
            # save some metadata for later
            shift DIFF_PATH
            printf 'project.repo["%s"]="%s"\n' "${REPO_LINK_PATH}" "${_PROJECT_VCS_ROOT:t}" >>"${_TASK_ROOT_DIR}/.project"
            printf 'project.path["%s"]="./%s"\n' "${REPO_NAME#-}" "${(j:/:)DIFF_PATH}" >>"${_TASK_ROOT_DIR}/.project"
            [[ ${DIFF_PATH} ]] && printf 'project.import=%s\n' "${(j:.:)DIFF_PATH}" >>"${_TASK_ROOT_DIR}/.project"
            # Move to the task directory
            pushd "${TASK_ROOT_DIR}/${_NEW_TASK}" &>/dev/null
                # Create new working dir for the repo
                # The new working dir  will be <PROJECT>/<TASK>/.workdir-<repo>
                [[ -h ${REPO_NAME#-} ]] || ln -s .workdir${REPO_NAME} "${REPO_NAME#-}" &>/dev/null
                # Create a link to the same rel path as the original
                DOT_PATH=${(j:.:)DIFF_PATH#.}
                DOT_PATH=${DOT_PATH#.}
                if [[ ${DOT_PATH} ]]; then
                    if [[ -h ${DOT_PATH} ]] ; then
                        printf "[WARN] diff path \"%s\" exists; deleting link\n" ${DOT_PATH} >&2
                        rm ${DOT_PATH}
                    fi
                    if [[ -e ${DOT_PATH} ]] ; then
                        printf "[ERROR] diff path \"%s\" exists and is not a link\n" ${DOT_PATH} >&2
                    else
                        # link to the same rel path as our main link
                        [[ -h "${REPO_NAME##-}-${DOT_PATH}" ]] || ln -vs .workdir${REPO_NAME}/${(j./.)DIFF_PATH} "${REPO_NAME##-}-${DOT_PATH}" &>/dev/null
                        # link to buck find buckconfig
                    fi

                fi
                _BUCK_VCS_ROOT="${repo_or_link:A}"
                while ! [[ -e "${_BUCK_VCS_ROOT%/}/.buckconfig" ]]; do
                    [[ "${_BUCK_VCS_ROOT}" -ef "${HOME}" || "${_BUCK_VCS_ROOT}" -ef '/' ]] && { _NOPE=1; break; }
                    _BUCK_VCS_ROOT=${_BUCK_VCS_ROOT:h}
                done
                # ${_PROJECT_VCS_ROOT##${_BUCK_VCS_ROOT}}
                if [[ -e ${_BUCK_VCS_ROOT}/.buckconfig ]]; then
                    typeset -a _INT_DIFF=()
                    _INT_PATH="${_BUCK_VCS_ROOT}"
                    while [[ -e "${_INT_PATH%/}/.buckconfig" ]]; do
                        [[ "${_INT_PATH}" -ef "${HOME}" || "${_INT_PATH}" -ef '/' ]] && { _NOPE=1; break; }
                        _INT_DIFF+=("${_INT_PATH:t}")
                        _INT_PATH="${_INT_PATH:h}"
                    done
                    if [[ ${#_INT_DIFF} -le 1 ]]; then
                        ln -vs .workdir${REPO_NAME}/buck-out/gen/${(j./.)DIFF_PATH[2,-1]} "buck-${DOT_PATH}" &>/dev/null
                    else
                        ln -vs .workdir${REPO_NAME}/${(0j:/:)_INT_DIFF[1,-2]}/buck-out/gen/${(j./.)DIFF_PATH[2,-1]} "buck-${(0j:.:)_INT_DIFF}-${DOT_PATH}" &>/dev/null
                    fi
                fi
            popd &>/dev/null
        done
        )
        return $?
    fi
    return 4
}

function _fb_projects_helper_add_bookmarks_from_list() {
    # FIXME: this function is pre-alpha
    local _SOMEID
    local _PROJNAME _LONGNAME=$(_fb_tmux_helper_get_session)
    _fb_projects_helper_project_shortname ${_LONGNAME} ${_NEW_TASK} 2>/dev/null | \
        read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 1
    echo $# $*
    while  [[ "$#" > 0 ]] ; do
        local repo="${1}"
        shift
        if _fb_projects_helper_is_valid_project "P+${_PROJNAME}-${_NEW_TASK}" >/dev/null; then
            # add task link to project
            # go to project home based on the project name
            pushd $(_fb_projects_helper_get_projects_home "P+${_PROJNAME}") &>/dev/null || return 1
            # setopt xtrace
            # Look for root working dir
            _PROJECT_VCS=${${:-"${PROJECT_ROOT_DIR%/}/${_PROJNAME}"}:A}
            # Fore each stdin
            printf 'Finding repo for %s' "${REPO}"
            ## The repo root, find it
            REPO_LINK_PATH=${repo_or_link:A}
            _PROJECT_VCS_ROOT="${REPO_LINK_PATH}"
            while ! [[ -d "${_PROJECT_VCS_ROOT%/}/.hg" ]]; do
                [[ "${_PROJECT_VCS_ROOT}" -ef "${HOME}" || "${_PROJECT_VCS_ROOT}" -ef '/' || -z "${_PROJECT_VCS_ROOT}" ]] && continue
                _PROJECT_VCS_ROOT=${_PROJECT_VCS_ROOT:h}
            done
            # get the name of the root repo dir
            REPO_NAME="${_PROJECT_VCS_ROOT:t}"
            [[ ${REPO_NAME} ]] && REPO_NAME="-${REPO_NAME}"

            # the relitive localtion in the workin copy of the project link
            declare -a DIFF_PATH=("${(s./.)REPO_LINK_PATH##${_PROJECT_VCS_ROOT}}")
            local ROOT_PATH="${DIFF_PATH[0]}"
            shift DIFF_PATH
            # Move to the project directory
            pushd "${_PROJECT_VCS}" &>/dev/null
            #####
            # Create a link to the same rel path as the original
            DOT_PATH=${(j:.:)DIFF_PATH#.}
            DOT_PATH=${DOT_PATH#.}
            if [[ ${DOT_PATH} ]]; then
                if [[ -h ${DOT_PATH} ]] ; then
                    printf "[WARN] diff path \"%s\" exists; deleting link\n" ${DOT_PATH} >&2
                    rm ${DOT_PATH}
                fi
                if [[ -e ${DOT_PATH} ]] ; then
                    printf "[ERROR] diff path \"%s\" exists and is not a link\n" ${DOT_PATH} >&2
                else
                    # link to the same rel path as our main link
                    ln -vs "./${ROOT_PATH#/}/${(j./.)DIFF_PATH}" "${_PROJNAME:l}-${REPO_NAME##-}-${DOT_PATH}"
                    # link to buck find buckconfig
                    _BUCK_VCS_ROOT="${repo_or_link:A})"
                    while ! [[ -e "${_BUCK_VCS_ROOT%/}/.buckconfig" ]]; do
                        [[ "${_BUCK_VCS_ROOT}" -ef "${HOME}" || "${_BUCK_VCS_ROOT}" -ef '/' ]] && { _NOPE=1; break; }
                        _BUCK_VCS_ROOT=${_BUCK_VCS_ROOT:h}
                    done
                    if [[ -e ${_BUCK_VCS_ROOT}/.buckconfig ]]; then
                        ln -vs "./${ROOT_PATH#/}/buck-out/gen/${(j./.)DIFF_PATH[2,-1]}" "buck.${DOT_PATH}"
                    fi
                fi
            fi
            ##### pop
            popd 2&>/dev/null
            #unsetopt xtrace
        fi ## end if is valide project
    done
    return 4
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
            2>/dev/null | read _SOMEID _PROJNAME _NEW_TASK
    [[ ${_PROJNAME} ]] || return 1
    if ! _fb_tasks_helper_is_valid_project  ${_NEW_TASK} ; then
        return 5
    elif ! _fb_projects_helper_is_valid_project ${_LONGNAME} >/dev/null; then
        return 4
    else
        (
        TASK_REL="../${PROJECT_FOLDER_NAME}"
        cd $(_fb_projects_helper_get_projects_home "P+${_PROJNAME}") &>/dev/null || exit 1
        if [[ ${TASK_REL} -ef ${PROJECT_ROOT_DIR} ]]; then
            ln -s "${TASK_REL}/${_NEW_TASK}" 2>/dev/null
        else
            ln -s "${PROJECT_ROOT_DIR}/${_NEW_TASK}" 2>/dev/null
        fi
        printf 'Subproject=%s' ${PWD:A} >>"${_TASK_ROOT_DIR}/.project"
        )
        return $?
    fi
}

function _fb_projects_helper_session_task () {
    local _SOMEID _PROJNAME _NEW_TASK
    _fb_projects_helper_project_shortname 2>/dev/null | read _SOMEID _PROJNAME _NEW_TASK  || return 2
    _fb_tasks_helper_set_task $_NEW_TASK || return 3
    _fb_projects_helper_clone_project_task "${_NEW_TASK}" "P+${_PROJNAME}"
    cd $(_fb_projects_helper_get_projects_home P+${_PROJNAME})/${_NEW_TASK}
}

function project_from_tmux() {
    local _TASK _PROJNAME _OTHERID
    local _tmux_session="$(_fb_tmux_helper_get_session)"
    _fb_projects_helper_project_shortname ${1} 2>/dev/null \
            | read _SOMEID _PROJNAME _TASK || return 2
    printf '%s' "${_PROJNAME}"
}

function prune_tasks () {
    cd $(_fb_projects_helper_get_projects_home) || return 1
    do_something=${1:-":"}
    for i in T*[^0](@); do
        tasks details $i | awk -F':' '/State :/{print $2}' | read STATE;
        if [[ $STATE == 'CLOSED' ]]; then
            echo "callikng ${do_something} on ${i}"
            export TASK_DIR=$i
            eval "${do_something} $TASK_DIR"
        fi
    done
}

alias create_project_task='_fb_projects_helper_clone_project_task'
alias get_projects_home='_fb_projects_helper_get_projects_home'
alias session_task_override='_fb_projects_helper_session_task'
alias cd_to_project_task_home='cd $(_fb_projects_helper_project_task_home)'
alias cdp='cd_to_project_task_home'
alias cd_to_task_home='cd ${${:-$(_fb_projects_helper_project_task_home)}:A}'
alias cd_to_project_home='cd ${${:-$(_fb_projects_helper_get_projects_home)}:A}'
alias project_task_home='_fb_projects_helper_project_task_home'
alias cd_to_project_task_home='cd $(_fb_projects_helper_project_task_home)'
alias cdp='cd $(_fb_projects_helper_project_task_home)'
alias cd_project_home='cd $(_fb_projects_helper_get_projects_home)'

alias new_project='_fb_projects_helper_get_projects_home'

alias summary='tasks summary $(task_from_tmux)'
alias all_tasks_summary='ls -d $(get_projects_home)/T[^0]*/ | while read task; do tasks summary ${task%/}; done'
