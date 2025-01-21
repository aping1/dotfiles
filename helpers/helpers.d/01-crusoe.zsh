function get-bmc   () {
[[ $1 ]] || return 1
gcloud secrets versions access 1 --secret=$(gcloud secrets list --filter="Labels.hostname : '$1'" | awk '{print $1}' | sed -n '2p')
}
