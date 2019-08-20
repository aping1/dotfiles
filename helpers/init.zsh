
export _HELPER_PLUGIN_DIR="${0:a:h}/helpers.d"

for FILE in ${~_HELPER_PLUGIN_DIR}/*.zsh(.) ; do     # regular files
    source "${FILE}"
done
