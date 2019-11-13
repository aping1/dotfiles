
 local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
 local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
 local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
 local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
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

function quick_sign_client() {
    setopt xtrace
    trap 'unsetopt xtrace' EXIT
    local _HOST="${1}"
    local CSR_PATH="${PWD}"
    [[ -d ${CERTROOT:="$(_fb_projects_helper_get_projects_home)/certs"} ]] || return 1
    local CERT_DEST_PATH="${CERTROOT%/}/${ENVIRONMENT}/${CONTINENT}/signed-certs/clients"
    local KEY_DEST_PATH="${CERTROOT%/}/${ENVIRONMENT}/${CONTINENT}/keys/clients"
    if ! openssl req -in "${CSR_PATH%/}.csr" -text -noout ; then
        [[ ${_HOST} ]] || return 2
        local _HOST_NAME="${2:-"${_HOST}.${DOMAIN#.}"}"
        local _KEY_FILEPATH=${3:-"${KEY_DEST_PATH}/${_HOST_NAME}"}
        [[ ${_HOST_NAME} ]] || return 3
        local _CN="${CN:-"/C=US/O=Palo Alto Networks Inc./OU=Apollo2_client/CN=${_HOST_NAME}"}"
        local CSR_PATH="${PWD}"
        if [[ -e ${_KEY_FILEPATH}.key ]] ; then
            printf -- 'Key exists (%s) Continue?:' ${_HOST_NAME}.key
            read -q || return 4
        fi
        if [[ -e "${CSR_PATH}" ]]; then
            printf -- 'CSR exists (%s) Continue?:' ${CSR_PATH}
            read -q || return 4
        fi
        [[ -d ${_KEY_FILEPATH:h} && -d ${_KEY_FILEPATH:h} ]] || return 5
        print -l 'Create CSR for (%s) in (%s:%s) ?' "${_CN}" "${CSR_PATH}" "${_KEY_FILEPATH}"
        if read -q ; then
            openssl req -new \
                -newkey rsa:2048 \
                -nodes \
                -keyout ${_KEY_FILEPATH}.key \
                -subj "${_CN}" > ${CSR_PATH}
        fi
        sign_csr "${CSR_PATH}"
    fi 
}

function quick_sign_server() {
    setopt xtrace
    trap 'unsetopt xtrace' EXIT
    local _HOST="${1}"
    [[ -d ${CERTROOT:="$(_fb_projects_helper_get_projects_home)/certs"} ]] || return 1
    local CERT_DEST_PATH="${CERTROOT%/}/${ENVIRONMENT:-.}/${CONTINENT:-.}/signed-certs/servers"
    local KEY_DEST_PATH="${CERTROOT%/}/${ENVIRONMENT:-.}/${CONTINENT:-.}/keys/servers"
    [[ ${_HOST} ]] || return 2
    local _HOST_NAME="${_HOST}"
    local CSR_PATH="${_HOST:a:h}/${_HOST_NAME}"
    local DOMAIN=${2}
    [[ ${DOMAIN} ]] && _HOST_NAME="${_HOST_NAME}.${DOMAIN#.}"
    local _KEY_FILEPATH="${${3:-"${KEY_DEST_PATH}/${_HOST_NAME}"}:gs/\*/_/}"
    _KEY_FILEPATH="${_KEY_FILEPATH%.key}"
    [[ "${_HOST_NAME}" ]] || return 3
    local _CN="${CN:-"/C=US/O=Palo Alto Networks Inc./OU=Apollo2_service/CN=${_HOST_NAME}"}"
    local CSR_PATH="${_HOST_NAME}"
    local CSR_PATH="${CSR_PATH:gs/\*/_/}.csr"
    if [[ -s ${_KEY_FILEPATH}.key ]] ; then
        printf -- 'Key exists (%s) Continue?:' ${_KEY_FILEPATH}.key
        read -q || return 4
    fi
    if [[ -e "${CSR_PATH}" ]] && openssl req -in "${CSR_PATH}" -text -noout &>/dev/null ; then
        printf -- 'CSR exists (%s) Continue?:' "${CSR_PATH}"
        read -q || return 4
    fi
    [[ -d ${_KEY_FILEPATH:h} && -d ${_KEY_FILEPATH:h} ]] || return 5
    printf --  'Create CSR for (%s) in (%s:%s) ?' "${_CN}" "${CSR_PATH}" "${_KEY_FILEPATH}".key
    if read -q ; then
        openssl req -new \
            -newkey rsa:2048 \
            -nodes \
            -keyout "${_KEY_FILEPATH}.key" \
            -subj "${_CN}" > ${CSR_PATH}
    fi
    sign_csr_server "${CSR_PATH}" "${CERT_DEST_PATH}" 
    printf --  'CN="%s"\nCSR_PATH="%s"\nKEY_PATH="%s"\n' "${_CN}" "${CSR_PATH}" "${_KEY_FILEPATH}".key

}

function sign_csr_server () {
    local _CSR_PATH=${1}
    [[ ${CSR_PATH} ]] || return 1
    local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
    [[ -d $_CERT_DEST_PATH ]] || return 2
    wrap_json ${CSR_PATH} | tee "${CSR_PATH}.json"| jq '.' | cat || return 3
    printf -- '----\n'
    openssl req -in "${CSR_PATH}" -text -noout 
    printf -- 'Sign ?' ${CSR_PATH}
    if ! read -q ; then
        printf -- 'Aborted:' 
    else
        curl https://apitrusted-devops.paloaltonetworks.local/api/manage/certificaterequest \
        -q \
        -X POST \
        -H "content-type: application/json" \
        --data-binary @"${CSR_PATH}.json" \
        --cacert $(project_home)/certs/prd/ca/PaloAltoNetworksIncSJCClientIssuingCA2G2-chain.pem \
        --key $(project_home)/certs/gw/keys/apollo2-prd-issuing.paloaltonetworks.com.key \
        --cert $(project_home)/certs/gw/signed-certs/Apollo2_issuing.pem | tee ${3:-"${_CERT_DEST_PATH}/${CSR_PATH:t:r}"}.json.out

        get_cert_out "${3:-"${_CERT_DEST_PATH}/${CSR_PATH:t:r}".json.out}" | tee ${CSR_DEST_FILEPATH}/${CSR_PATH:r:t}.pem | cat
    fi
}
function sign_csr_client () {
    local CSR_PATH=${1}
    [[ ${CSR_PATH} ]] || return 1
    local _CERT_DEST_PATH=${2:-${CSR_PATH:h}}
    [[ -d $_CERT_DEST_PATH ]] || return 2
    wrap_json ${CSR_PATH} | tee "${CSR_PATH}.json"| jq '.' | cat || return 3
    printf -- '----'
    openssl req -in "${CSR_PATH}" -text -noout 
    printf -- 'Sign ?' ${CSR_PATH}
    if ! read -q ; then
        printf -- 'Aborted:' 
    else
        curl https://apitrusted-devops.paloaltonetworks.local/api/manage/certificaterequest \
        -q \
        -X POST \
        -H "content-type: application/json" \
        --data-binary @"${CSR_PATH}.json" \
        --cacert $(project_home)/certs/prd/ca/PaloAltoNetworksIncSJCClientIssuingCA2G2-chain.pem \
        --key $(project_home)/certs/gw/keys/apollo2-prd-client.paloaltonetworks.com.key \
        --cert $(project_home)/certs/gw/signed-certs/Apollo2_client.pem | tee ${3:-"${_CERT_DEST_PATH}/${CSR_PATH:t:r}"}.json.out

        get_cert_out "${3:-"${_CERT_DEST_PATH}/${CSR_PATH:t:r}".json.out}" | tee ${3:-"${_CERT_DEST_PATH}/${CSR_PATH:t:r}"}.pem | cat
    fi
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




