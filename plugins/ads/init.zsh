# inventory
#for i in $(sudo gnt-instance list -o os --no-headers); do  IMAGE=${i##*+};  if grep ${IMAGE} /etc/ganeti/instance-image/variants.list &>/dev/null; then NEWIMAGE=$(grep ${IMAGE%-*} /etc/ganeti/instance-image/variants.list) ; echo "\"$IMAGE\" Should be: $NEWIMAGE";  fi;  done
# for i in $(sudo gnt-instance list -o os --no-headers); do  IMAGE=${i##*+};  if ! grep ${IMAGE} /etc/ganeti/instance-image/variants.list &>/dev/null; then NEWIMAGE=$(grep ${IMAGE%-*} /etc/ganeti/instance-image/variants.list); echo ${IMAGE%-*}; fi; done
# this checks when the deployed is out of date from variant
# sudo salt 'kaki*' cmd.run 'for i in $(sudo gnt-instance list -o os --no-headers); do  IMAGE=${i##*+};  if ! grep ${IMAGE} /etc/ganeti/instance-image/variants.list &>/dev/null; then NEWIMAGE=$(grep ${IMAGE%-*} /etc/ganeti/instance-image/variants.list); echo ${IMAGE%-*}; fi; done'
# sudo lsof -p $(sudo jps | grep spock | awk '{print $1}') | awk '{print $2}' | sort | uniq -c | sort
#
image_versions_from_ads() {
 [[ -n ${1} ]] && export ADS=${1} || echo "ERROR: please provide an ads"
 [[ -n ${2} ]] && export IMAGE=${2} || echo "ERROR: please provide and image"
 curl -X GET "http://${ADS:-localhost}:9090/provisioning/images/host/candidates/${IMAGE}" | jq --arg image "${IMAGE}" 'sort_by(.version) | .[] | select(.name == $image)| {"name" : .name, "version": .version}'
}

delete_images_versions_higher_than() {
 [[ -n ${1} ]] && export ADS=${1} || echo "ERROR: please provide an ads"
 [[ -n ${2} ]] && export IMAGE=${2} || echo "ERROR: please provide and image"
 [[ -n ${3} ]] && export HIGHEST=${2} || echo "ERROR: please provide and image"
 jq -. <<< $(image_versions_from_ads "$ADS" "$IMAGE")
 }

kaki_get_os_varient() {
    if [[ ${1} == "-h" or ${1} == "--help" ]]; then
        printf 'Usage: unpack_hajime_context ENV=ait1 OUTPUT_DIR=/tmp/test' >2
        exit 1 
    fi
    IMAGES=( ${*} )
    SEARCH=$(for i in ${IMAGES[*]}; do printf '%s\|' ${i}; done)
    for os in ${IMAGES[*]}; do printf '****** %s  ' $os; grep $os /etc/ganeti/instance-image/variants.list ; echo; done | grep ${SEARCH}
}

unpack_context () {
    if [[ ${1} == "-h" or ${1} == "--help" ]]; then
            printf 'Usage: unpack_hajime_context ENV=ait1 OUTPUT_DIR=/tmp/test' >2
            exit 1
    fi
    if ! which hajime-server; then
          printf 'WARNING: Could not find "hajime-server" executable'
          exit 1
    fi
    OUTPUT=$(realpath ${2})
    (
        trap _cleanup EXIT SIGINT
        _cleanup() {
            trap '' EXIT SIGINT
            if [[ -z ${DEBUG} && "${OUTPUT}" == ${MKTEMP} ]]; then
                rm -rf "${MKTEMP}"
            else
                printf 'Warning: will not delete directory. Leaving artifacts at "%s"' "${OUTPUT}" >2 
            fi
            exit 0
        }

        MKTEMP="$(mktemp -d "/tmp/unpack_test.$(now).XXXX")"
        OUTPUT=${OUTPUT:-${MKTEMP}}
            ENV=${1:-ait1}
        if ! [[ -d "${OUTPUT}" ]]; then
            printf 'ERROR: Output directory "%s" is not a directory' "${OUTPUT}" >2
            return 1
        elif if ! [[ -d "/tmp/${ENV}" ]]; then
            printf 'ERROR: Output directory "%s" is not a directory' "/tmp/${ENV}" >2
        fi
        [[ -z ${OUTPUT} ]] &&  exit
        if [[ ${1} == "-h" or ${1} == "--help" ]]; then
            printf 'Usage: unpack_hajime_context ENV=ait1 OUTPUT_DIR=/tmp/test' >2
        fi
        pushd  $(dirname ${OUTPUT})
        gzcat /tmp/${ENV}/clusters/*/racks/*/hosts/mk1/hajime-server-context.json.gz > "${OUTPUT}/hajime-server-context.json" && hajime-server -T ~/code/gaikai.sre.hajime-server/resources/templates -I ~/code/gaikai.sre.hajime-server/resources/include -c "${OUTPUT}/hajime-server-context.json" -o "${OUTPUT}"
        popd
    ); exit $?
}
