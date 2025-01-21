#!/usr/bin/env zsh
## Check if 'kubectl' is a command in $PATH
if [ $commands[kubectl] ]; then

  # Placeholder 'kubectl' shell function:
  # Will only be executed on the first call to 'kubectl'
  kubectl() {

    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"

    # Load auto-completion
    source <(kubectl completion zsh)

    # Execute 'kubectl' binary
    $0 "$@"
  }
fi

  # -E: remove $@ -D: ignore unknonw
function kgetall { 
  zparseopts -E -D -- \
           n+:=o_namespace -namespace+:=o_namespace
  typeset -A helper
  o_namespace=("${(@)o_namespace:#-n#--namespace}")
  if ! (( #o_namespace )); then
     kubectl api-resources --verbs=list --namespaced -o name | xargs -n1 kubectl get --show-kind --ignore-not-found
     return 0
  fi
  helper=($(seq 1 ${#o_namespace}))
  for ns in ${(@v)helper}; do
     [[ ${o_namespace[$ns]} ]] || continue
     printf 'Namespace: %s \n' "${o_namespace[$ns]}"
     kubectl api-resources --verbs=list --namespaced -o name | xargs -n1 kubectl --namespace "${o_namespace[$ns]}" get --show-kind --ignore-not-found
  done
}


export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"

complete -F __start_kubectl kgetall
