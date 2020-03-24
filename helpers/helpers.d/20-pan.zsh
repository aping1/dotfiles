
alias deploy_container='() {[[ "${1}" ]] || return 1; cd $(task_home)/deployment && KEY_PATH=$(get_projects_home) SKIP_VERIFY=y scripts/docker_build.sh all $@} '

alias gwhoami='gcloud config list account --format "value(core.account)"'


function cortex_prd() {
export VAULT_TOKEN=$(cat ~/.vault-token.prd)
export VAULT_ADDR="https://vault.gns-prod-shared-infra.gcp.pan.local";
export SKIP_VERIFY=1
( cortex_parse_and_export ${1} && \
    cd $(get_projects_home  || echo -n '.')/deployment/ && \
    python3 scripts/cdt  run --force --bundle --key-file $(get_projects_home || echo -n '..')/${ENVIRONMENT}.key.json )
}

function cortex_dev() {
export VAULT_ADDR="https://vault.gns-dev-shared-infra.gcp.pan.local"; 
export VAULT_TOKEN=$(cat ~/.vault-token.dev)
export SKIP_VERIFY=1
( [[ $1 ]] && cortex_parse_and_export ${1}  
    cd $(get_projects_home || echo -n '.')/deployment/ && \
    python3 scripts/cdt  run --force --bundle --key-file $(get_projects_home || echo -n '..')/${ENVIRONMENT:-dev}.key.json )
}

function cortex_parse_and_export () {
    # Function to get PROJECT_BASE ENVIRONMENT and COUNTRY from the requested project
    local proj=${1}
    [[ ${proj} ]] || return 2
    IFS='-' read -r PROJ_PREFIX PROJECT_BASE COUNTRY <<< "${proj}"
    export ENVIRONMENT="${PROJECT_BASE%[0-9]}"
    if [[ ${PROJ_PREFIX} == 'dev' ]]; then
        # Re parse if dev is first
        IFS='-' read -r ENVIRONMENT PROJ_PREFIX PROJECT_BASE COUNTRY <<< "${proj}"
    elif [[ ${ENVIRONMENT} == 'perf' ]]; then
        ENVIRONMENT='stg'
    fi
    export COUNTRY="${COUNTRY:-us}"
    export PROJ_PREFIX
    export PROJECT_BASE
    if [[ ! ${SKIP_VERIFY} ]] && ! gcloud projects list --filter "$proj" | cut -d' ' -f1 | grep '^'"${proj}"'$' ; then 
        error "Unknown project $proj"
        return 2
    fi
    export PROJECT="${proj}"
}

get_cert_out() {
    [[ -e "${1}" ]] || return 1
    jq -r '.cert' "${1}"
}

usage () {
	printf -- '%s [client|service]' "${0}"
}

wrap_json () {
	command -v jq &>/dev/null || return 2
	[[ ${1} ]] || return 3
	#jq '.' <(echo -n '{"csr": "'; sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' < "${1}" | tr -Cd '[[:print:]]' ; echo -n '"}')
	jq '.' <(echo -n '{"csr": "'; tr -d '\n' < "${1}" ; echo -n '"}')
	#jq '.' <(echo -n '{"csr": "'; base64 < "${1}" | tr -Cd '[[:print:]]' ; echo -n '"}' | tee /dev/stderr )
}

function vault-ldap-token () { 
case ${1} in 
    'dev') 
        local vaultaddr=https://vault.gns-dev-shared-infra.gcp.pan.local 
        ;;
    'prod')
        local vaultaddr=https://vault.gns-prod-shared-infra.gcp.pan.local 
        ;;
    'normal')
        vault login -token-only -method=ldap username=$(whoami)
        return $?
        ;;
    *)
        local vaultaddr=http://127.0.0.1
    ;;
esac
vault login -address=${vaultaddr} -token-only -method=ldap username=$(whoami)
}
function list_all_gcr_images () {
    local DEST_FILE
    local IMAGE_REPO=${1:-gcr.io/gcp-eng-apollo-dev}
    [[ ${IMAGE_REPO} ]] || return 1 
    if [[ ${IMAGE_REPO} =~ '/' ]]; then
        DEST_FILE=images-list-${IMAGE_REPO##*\/}-$(date '+%F').txt
    else
        DEST_FILE=images-list-${IMAGE_REPO}-$(date '+%F').txt
    fi
    [[ -s ${DEST_FILE} ]] && {
        echo "Destination \"${DEST_FILE}\" is not empty..." >&2;
        printf -- '%s\n' "${DEST_FILE}"; 
        return 2;
    }
    jq -r 'map(.name)| join("\n")' < <(gcloud container images list --repository="${IMAGE_REPO}" --format=json | tee ${image_repo}.$(date '+%F').json) > "${DEST_FILE}"
    [[ -s ${DEST_FILE} ]] || return 2
    wc -l  "${DEST_FILE}"  >&2
    printf -- '%s\n' "${DEST_FILE}"
}

function tags_for_image_list() {
    local image_list=${1}
    local repo=${2:-"gcr.io/gcp-eng-apollo-dev"}
    local COUNT=${4:-0}
    local temp=$3
    [[ ${COUNT} -eq 0 ]] || {echo "Warning: count started at ${COUNT}" >&2;}; for line in 
    [[ -s ${1} ]] || { echo "please provide and imagelist to $1"; }
    NLINE_COUNT=$(wc -l ${image_list})
    image_list="$(_realpath ${image_list})"
    if [[ ${COUNT} -gt ${NLINE_COUNT} ]] ; then
        echo "Error: count started at ${COUNT}, but ${image_list} on has ${NLINE_COUNT} lines" >&2;
        return 1
    fi
    temp=${3:-$(mktemp -du)} 
    [[ -d ${temp} ]] || return 1

    pushd ${temp}
    [[ -s ${1} ]] || { echo "Error resolving image list from \$1, provided ${image_list}"; }

    while read line; do
        (( COUNT += 1))
        echo "${COUNT}/${NLINE_COUNT}: " >&2
        export line
        gcloud container images list-tags ${repo}/$line --format json  | jq 'map(. + {image:($ENV.line)})[]' > ${line}-tags.json &
        echo "$\!"  >> ./pids
        if (( COUNT % 5 == 0 )); then
            wait $(cat ./pids )
            echo -n > ./pids
        fi
    done  < "${image_list}"
    popd
    echo "You'll want to clean up: ${temp}" >&2
    echo "${temp}"
    }

alias vault-dev-ldap-token='vault-ldap-token dev'
alias vault-prod-ldap-token='vault-ldap-token prod'
alias vault-local-ldap-token='vault-ldap-token ""'
alias vault-login='vault-ldap-login normal'

function docker_projects () {
	for dock in $(docker ps -aq)
	do
		echo -n "$dock "
		docker exec $dock bash -c 'echo $PROJECT'
	done
}
