export _HELPER_PLUGIN_DIR="${0:a:h}/helpers.d"

for HELPER in ${_HELPER_PLUGIN_DIR}/*.zsh(.); do     # regular files
    # echo "HelperScript ${HELPER}" >&2
    source ${HELPER}
done
