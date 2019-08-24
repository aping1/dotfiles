
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/awampler/projects/apollo2/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/awampler/projects/apollo2/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/awampler/projects/apollo2/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/awampler/projects/apollo2/google-cloud-sdk/completion.zsh.inc'; fi

run_bundle() {                                                                                                                                                             ✔  6930  16:09:24
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
 gcloud auth activate-service-account --key-file key.json && ./scripts/run.sh run_bundle || gcloud beta compute --project "$proj" ssh --zone "us-central1-a" "bastion01-us-${ENVIRONMENT}" --tunnel-through-iap
done
}
