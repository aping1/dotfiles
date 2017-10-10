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
 for os in ${IMAGES[*]}; do printf '****** %s  ' $os; ag $os /etc/ganeti/instance-image/variants.list ; echo; done | grep "skywalker\|pegasus\|charon\|rainbow\|gameboy\|obiwan"
 }
