function get-bmc   () {
[[ $1 ]] || return 1
gcloud secrets versions access 1 --secret=$(gcloud secrets list --filter="Labels.hostname : '$1'" | awk '{print $1}' | sed -n '2p')
}

c_get_bmc () {
  local HOST=${1}
  [[ $HOST ]] || return 1
  ( 
  setopt xtrace
  cd ~/code/scripts/ipmi_tools
  export NETBOX_API_TOKEN="$(kubectl --context gke_island-prod_us-central1_island-prod --namespace refinery \
  get secrets refinery  --output json | jq -r '.data.REFINERY_NETBOX_TOKEN' | base64 -d)"
  ./get-ipmi-creds.sh "$HOST"
  )
}

c_set_agent_mode () {
        setopt xtrace
        [[ -n $1 ]] || return 1
        [[ -n $2 ]] || return 1
        local NODE="$1" MODE="$2"
        shift 2
        export NETBOX_API_TOKEN="$(kubectl --context gke_island-prod_us-central1_island-prod --namespace refinery \
  get secrets refinery  --output json | jq -r '.data.REFINERY_NETBOX_TOKEN' | base64 -d)"
        [[ $NETBOX_API_TOKEN ]] || return 2
        cloud-admin nodes set-config --node-names "$NODE" --mode ${MODE:-AGENT_MODE_FREEZE_ENV} ${*}
        unsetopt xtrace
}

alias  claim="cloud-admin nodes add-claim --node-names"
alias   burnin="cloud-admin workflow nodes burnin --node-names "
alias   burnshort="cloud-admin workflow nodes burnin --dcgmi-level 4 --tests 'cpu,gpu,network,ib' --node-names "
alias       ca="cloud-admin"
alias       cals="cloud-admin nodes list --show NAME,TYPE,MODE      --node-names "
alias      calsn="cloud-admin nodes list --show NAME,TYPE,MODE,NOTE --node-names "
alias   config="cloud-admin workflow nodes config --node-names "
alias       hi="cloud-admin nodes agent-mode-history --show NODE_NAME,MODE,TRANSITION_TIME      --node-names "
alias     hist="cloud-admin nodes agent-mode-history --show NODE_NAME,MODE,TRANSITION_TIME,NOTE --node-names "
alias c_poweroff="cloud-admin hosts update --action off --hostname "
alias  c_poweron="cloud-admin hosts update --action on  --hostname "
alias      res="cloud-admin nodes get-reservations  --node-names "
alias      vms="cloud-admin vms list --show NODE_NAME,NAME,VM_ID,PROJECT,ORG,CREATED_AT --node-name "
alias      cavms="vms list --show name,project_id,node_name,state,reservation_id,created_at,maintenance_policy --node-name "
alias      ztp="cloud-admin workflow nodes reprovision --node-names "

function c_pw() {

  local HOST=${1}
  [[ $HOST ]] || return 1
  ( 
    cd ~/code/scripts/ipmi_tools &>/dev/null
    export NETBOX_API_TOKEN="$(kubectl --context gke_island-prod_us-central1_island-prod --namespace refinery \
get secrets refinery  --output json | jq -r '.data.REFINERY_NETBOX_TOKEN' | base64 -d)"
    [[ $NETBOX_API_TOKEN ]] || return 2
    ./get-ipmi-creds.sh -e "$1" \
		      | tee /dev/tty   \
		      | awk '{
                      if ($2 == "IP:")       {printf "export bmc_ip=%s\n", $3 }
			          if ($2 == "password:") {printf "export bmc_password=%s\n", $3 }
    			      if ($2 == "username:") {printf "export bmc_username=%s\n", $3 }
                	  }' 
   )

}

function c_boot_to_bios () {
  local HOST=${1}
  [[ $HOST ]] || return 1
  source <(c_pw $HOST)
  ipmitool -I lanplus -H $bmc_ip -U $bmc_username -P $bmc_password chassis bootdev bios
}

function now() {
  date '+%F-%H%M_%S'
}

function c_crawler_logs () {
trap 'unset xtrace' RET
[[ $CIS_HOST && $CIS_PASSWORD ]] || { echo "please provide cis_host and pass" >&2 ; return 2; }
[[ $1 ]] ||  { echo "please provide host" >&2 ; return 2; }
export host=$1
c_op_crusoe 
cat > password.sh << eof
#!/bin/bash
echo -n "$(op item get "${CIS_PASSWORD}" --fields password --reveal)"
eof
chmod +x password.sh
setopt xtrace
[[ "$(wc -c password.sh | awk '{print $1}')" -gt 7 ]]  || {echo "could not get password https://start.1password.com/open/i?a=rmo5ro5mbrdl7dopzbtok6w7eq&v=z5mmc5zuyppjdxcjgkj5r2txhi&i=bdrnjjwrde2jwh7a5rxim3m2zm&h=crusoeenergysystemsinc.1password.com" >&2; return 5; }
[[ -x ./password.sh ]] || { echo "COULDNT read passowrd" >&2; return 253; }
source <(c_pw "$host")
export SSH_ASKPASS='./password.sh' SSH_ASKPASS_REQUIRE=FORCE
mkdir $host
ssh crusoe@"$CIS_HOST" -- /opt/cray/redfish-tools/bin/get-redfish-info -u "${BMC_USER:-"$bmc_username"}" -p "${BMC_PW:-"$bmc_password"}" "${bmc_ip:-"${bmc_ip}"}" | tee >(awk '/Output file:/{print $3}' | head -n1 | read RFOUTPUTFILE ; echo scp crusoe@$CIS_HOST:$RFOUTPUTFILE $host/ ) | tee >(awk '/Log file:/{print $3}' | head -n 1| read RFLOGFILE; echo scp crusoe@$CIS_HOST:$RFLOGFILE $host/); 
}

function c_ssh_cis {
[[ $CIS_HOST && $CIS_PASSWORD ]] || { echo "please provide cis_host and pass pointer" >&2 ; return 2; }
export host=$1
c_op_crusoe 
cat > password.sh << eof
#!/bin/bash
echo -n "$(op item get "${CIS_PASSWORD}" --fields password --reveal)"
eof
chmod +x password.sh
[[ "$(wc -c password.sh | awk '{print $1}')" -gt 7 ]]  || {echo "could not get password https://start.1password.com/open/i?a=rmo5ro5mbrdl7dopzbtok6w7eq&v=z5mmc5zuyppjdxcjgkj5r2txhi&i=bdrnjjwrde2jwh7a5rxim3m2zm&h=crusoeenergysystemsinc.1password.com" >&2; return 5; }
[[ -x ./password.sh ]] || { echo "COULDNT read passowrd" >&2; return 253; }
(
 (( $+DEBUG )) && { setopt xtrace; trap 'unsetopt xtraxe' QUIT HUP; }
  export SSH_ASKPASS='./password.sh' SSH_ASKPASS_REQUIRE=FORCE
  ssh-keygen -R "$CIS_HOST"
  ssh crusoe@"$CIS_HOST" 
)
}

function c_op_crusoe {
# https://start.1password.com/open/i?a=LW25M4PRARHS3OEBZS6IAVOI2I&v=nftbjfvxzu4g5x4xpauznaggzm&i=pyophqldfqf4kot5htybyesdam&h=my.1password.com
# https://start.1password.com/open/i?a=LW25M4PRARHS3OEBZS6IAVOI2I&v=nftbjfvxzu4g5x4xpauznaggzm&i=pyophqldfqf4kot5htybyesdam&h=my.1password.com
op --account V6B7FMWWAVAI7KT4AOVP74SV74 item get pyophqldfqf4kot5htybyesdam --fields password --reveal | tee >(spbcopy) | base64

}
