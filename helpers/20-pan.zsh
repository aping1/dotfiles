
alias deploy_container='() {[[ "${1}" ]] || return 1; cd $(task_home)/deployment && KEY_PATH=$(get_projects_home) SKIP_VERIFY=y scripts/docker_build.sh all $@} '

cortex_parse_and_export () {
    # Function to get PROJECT_BASE ENVIRONMENT and CONTINENT from the requested project
    local proj=${1}
    [[ ${proj} ]] || return 2
    IFS='-' read -r PROJ_PREFIX PROJECT_BASE CONTINENT <<< "${proj}"
    export ENVIRONMENT="${PROJECT_BASE%[0-9]}"
    if [[ ${PROJ_PREFIX} == 'dev' ]]; then
        # Re parse if dev is first
        IFS='-' read -r ENVIRONMENT PROJ_PREFIX PROJECT_BASE CONTINENT <<< "${proj}"
    elif [[ ${ENVIRONMENT} == 'perf' ]]; then
        ENVIRONMENT='stg'
    fi
    export CONTINENT="${CONTINENT:-us}"
    export PROJ_PREFIX
    export PROJECT_BASE
    if [[ ! ${SKIP_VERIFY} ]] && ! gcloud projects list --filter "$proj" | cut -d' ' -f1 | grep '^'"${proj}"'$' ; then 
        error "Unknown project $proj"
        return 2
    fi
    export PROJECT="${proj}"
}


