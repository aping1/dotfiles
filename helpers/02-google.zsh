
# The next line updates PATH for the Google Cloud SDK.
	if [ -f '/Users/awampler/projects/Apollo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/awampler/projects/Apollo/google-cloud-sdk/path.zsh.inc'; else echo "failed to load google" >&2; fi

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

function push_istio_secrets () {
	export VAULT_ADDR="https://vault.gns-prod-shared-infra.gcp.pan.local"
	[[ -f ~/.vault-token ]] || vault login -method=ldap username=$(whoami)
	export VAULT_TOKEN=$(cat ~/.vault-token)
	[[ ${VAULT_TOKEN} ]] || return 1
	for proj in ${*}; do
		ALL_THINGS=("${(@s/-/)proj}")
		export PROJECT_BASE="${ALL_THINGS[2]}"
		export ENVIRONMENT="${PROJECT_BASE%[0-9]}"
		export CONTINENT="${ALL_THINGS[3]}"
		export CONTINENT="${CONTINENT:-us}"
		if gcloud config set project "${proj}" | grep "does not exist"; then
			echo "FAILED TO SET $proj"
			return 2
		fi
		export PROJECT="${proj}"
        [[ -s ${ENVIRONMENT}.key.json ]] || { echo "missing ${ENVIRONMENT}.key.json  in pwd"; continue; }
		cat ${ENVIRONMENT}.key.json > key.json
		[[ -s key.json ]] || return 3
		echo ENVIRONMENT=$ENVIRONMENT
		(
		setopt xtrace
		function _done() { 
			set +e
			unsetopt xtrace
			[[ ${CLEANUP:n} =~ '^[Yy]' && "${TMP_FOLDER}" ]] && rm -r ${TMP_FOLDER}
		}
	trap '_done $?' exit 
	TMP_FOLDER=$(mktemp -d "istio-${ENVIRONMENT}-${CONTINENT}-XXX" )
	[[ -d ${TMP_FOLDER} ]] || {echo "Failed to make ${TMP_FOLDER}"; exit 1; }
    cd "${TMP_FOLDER}"
	ISTIO_PATH="cortex/${ENVIRONMENT}/${CONTINENT}/istio"
	echo "modifying ${ISTIO_PATH}"
	vault kv get -field=base64 "${ISTIO_PATH}" | base64 --decode > ./istio.tgz || break
	tar xvzf istio.tgz && cat ../${ENVIRONMENT}/${CONTINENT}/ca/*  > ca.cert.pem
	[[ -s ca.cert.pem ]] || { echo "No ca cert"; exit 2; }
	# tar and push
    cat ../${ENVIRONMENT}/${CONTINENT}/signed-certs/servers/cdl.nl.paloaltonetworks.com.pem > root-cert.pem 
    cat ../${ENVIRONMENT}/${CONTINENT}/keys/servers/cdl.nl.paloaltonetworks.com.key > key.pem
	read ANSWER'?Pushing to ${ISTIO_PATH}'
	[[ ${ANSWER} =~ [Yy] ]] && tar -cvzf - *.pem | tee istio-new.tgz | base64 | vault kv put "${ISTIO_PATH}" base64=- && vault kv get -field=base64 "${ISTIO_PATH}" | base64 --decode | tar tvzf -
	)
done
}
