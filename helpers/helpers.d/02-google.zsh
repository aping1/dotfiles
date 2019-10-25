
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/awampler/projects/Apollo/google-cloud-sdk/path.zsh.inc' ]; then 
    source '/Users/awampler/projects/Apollo/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
    if [ -f '/Users/awampler/projects/Apollo/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/awampler/projects/Apollo/google-cloud-sdk/completion.zsh.inc'; else echo "failed to load google" >&2 ; fi

    run_bundle() {
        export VAULT_ADDR="https://vault.gns-prod-shared-infra.gcp.pan.local"
        [[ -f ~/.vault-token ]] || vault login -method=ldap username=$(whoami)
        export VAULT_TOKEN=$(cat ~/.vault-token)
        [[ ${VAULT_TOKEN} ]] || return 1
        for proj in ${*}; do
            ALL_THINGS=("${(@s/-/)proj}")
            export PROJECT_BASE="${ALL_THINGS[2]}"
            export ENVIRONMENT="${PROJECT_BASE%[0-9]}"
            export CONTINENT="${ALL_THINGS[3]}"
            if gcloud config set project "${proj}" | grep "does not exist"; then
                echo "FAILED TO SET $proj"
                return 2
            fi
            export PROJECT="${proj}"
            cat ../${ENVIRONMENT}.key.json > key.json
            echo ENVIRONMENT=$ENVIRONMENT
            gcloud auth activate-service-account --key-file key.json && python ./scripts/cortex run || gcloud beta compute --project "$proj" ssh --zone "us-central1-a" "bastion01-us-${ENVIRONMENT}" --tunnel-through-iap
        done
    }

function check_socks () {
    # Magic numbers from socks5 rfc
    xxd -p -r <<< 050100 | nc localhost 1080 | base64
}

alias check_socks_up='[[ $(check_socks | tr -d '\n') == BQA= ]]'

function kube_prompt () {
    if ! [[ ${SPACESHIP_PROMPT_ORDER[(ie)kubecontext]} -le ${#SPACESHIP_PROMPT_ORDER} ]] ; then 
        local SEP_SPACE="${SPACESHIP_PROMPT_ORDER[(ie)line_sep]}"
        if [[ ${SEP_SPACE} -le ${#SPACESHIP_PROMPT_ORDER} ]]; then
            SPACESHIP_PROMPT_ORDER=( "${SPACESHIP_PROMPT_ORDER[@]:0:$((SEP_SPACE))}" kubecontext "${SPACESHIP_PROMPT_ORDER[@]:$((SEP_SPACE))}" )
        else
            SPACESHIP_PROMPT_ORDER+=(kubecontext)
        fi
    fi

    if [[ -s "${KUBECONFIG:-$HOME}/.kube_config" ]] && kubectl get version; then
        return 0
    fi
}

function kube_connect () {
    local _CLUSTER_ZONE
    local _SCHEMA
    local _OHNO
    local _ADDRESS
    local _CONNECTED
    local ADDRESS_PATH
    local _NAME 
    # Function to get PROJECT_BASE ENVIRONMENT and CONTINENT from the requested project
    if [[ -d "${TASK_ROOT_DIR:-"${HOME}/tasks"}/$(task_from_tmux)/" ]]; then
        export KUBECONFIG="${TASK_ROOT_DIR:-"${HOME}/tasks"}/$(task_from_tmux)/.kube_config"
        printf -- 'export KUBECONFIG="%s"\n' "${TASK_ROOT_DIR:-"${HOME}/tasks"}/$(task_from_tmux)/.kube_config"
    fi


    local proj=${1}
    [[ ${proj} ]] || { echo "Requires project argument" >&2; return 2}
    IFS='-' read -r PROJ_PREFIX PROJECT_BASE CONTINENT <<< "${proj}"
    export ENVIRONMENT="${PROJECT_BASE%[0-9]}"
    if [[ ${PROJ_PREFIX} == 'dev' ]]; then
        # Re parse if dev is first
        IFS='-' read -r ENVIRONMENT PROJ_PREFIX PROJECT_BASE CONTINENT <<< "${proj}"
    elif [[ ${ENVIRONMENT} == 'perf' ]]; then
        ENVIRONMENT='stg'
    fi
    local CONTINENT="${CONTINENT:-us}"
    local PROJ_PREFIX
    local PROJECT_BASE
    local PROJECT="${proj}"

    check_socks_up && return 1
    # Start parsing cluster infoKUBE_CLUSTER_ZONE

    if ! [[ ${KUBE_CLUSTER_NAME} && ${KUBE_CLUSTER_ZONE} ]]; then
        gcloud --project "${PROJECT}" container clusters list | tail -n1 | read KUBE_CLUSTER_NAME KUBE_CLUSTER_REGION KUBE_MASTER_VERSION KUBE_MASTER_IP KUBE_MACHINE_TYPE KUBE_NODE_VERSION REMAINING
    fi

    read KUBE_NUM_NODES KUBE_CLUSTER_STATUS OTHER <<< ${REMAINING#[\*]*}
    [[ ${KUBE_CLUSTER_STATUS} == 'RUNNING' ]] || return 3
    # Tunneling traffic for kubectl
        gcloud --project="${proj}" compute instances list --filter='tags.items=bastion' --format=json | jq -r '.[] | "\(.zone)/\(.name)"' | \
            while IFS='/' read _SCHEMA _OHNO _ADDRESS ADDRESS_PATH; do 
                read SELECT_BASTION'?test'  #Inter active
                [[ ${SELECT_BASTION} =~ ^[Yy][eE]?[sS]? ]] && continue
                _NAME="${ADDRESS_PATH:t}"
                _CLUSTER_ZONE="${ADDRESS_PATH:h:t}"
                if  gcloud beta compute ssh --tunnel-through-iap --zone="${_CLUSTER_ZONE}" --project="${proj}" "terraform@${_NAME}" -- -Nn -D 1080 >&2 ; then
                    _CONNECTED=1
                fi
            done
        [[ "${_CONNECTED}" -eq 1 ]] || return 2
        if gcloud container clusters get-credentials "${KUBE_CLUSTER_NAME}" --region "${KUBE_CLUSTER_REGION}" --project "${PROJECT}" >&2 ||  gcloud container clusters get-credentials "${KUBE_CLUSTER_NAME}" --zone "${KUBE_CLUSTER_ZONE}" --project "${PROJECT}" >&2 ; then
            :
        else
            return 3
        fi
        printf -- 'RESPONSE="%s" \n' "$(check_socks)"
        printf -- 'export HTTPS_PROXY=socks5://localhost:1080
        export NO_PROXY="localhost,*.googleapis.com,*.google.com,*.hashicorp.com"
        export ENVIRONMENT="%s"
        export CONTINENT="%s"
        export PROJ_PREFIX="%s"
        export PROJECT_BASE="%s"
        export PROJECT="%s"\n' \
            "${ENVIRONMENT}" \
            "${CONTINENT}" \
            "${PROJ_PREFIX}" \
            "${PROJECT_BASE}" \
            "${PROJECT}"
    printf -- 'export KUBE_CLUSTER_NAME="%s"
    export KUBE_CLUSTER_REGION="%s"
    export KUBE_MASTER_VERSION="%s"
    export KUBE_MASTER_IP="%s" \n' \
        "${KUBE_CLUSTER_NAME}" \
        "${KUBE_CLUSTER_ZONE:-"${KUBE_CLUSTER_REGION}"}" \
        "${KUBE_MASTER_VERSION}" \
        "${KUBE_MASTER_IP}"
    printf -- 'export SPACESHIP_PROMPT_ORDER=(%s) \n' \
                                            "${SPACESHIP_PROMPT_ORDER[*]}"

                                        }
else 
    echo "failed to load google" >&2; fi
fi
