
function use_editor () {
    : ${_OLDFILE:=${1:-${OLDFILE}}}
    : ${_TEMPFILE:="$(mktemp /tmp/.XXXXXXXXXX)"}
    [[ -f ${_TEMPFILE} ]] || return 3
    exec {FD}<${_TEMPFILE}
    [[ -s ${_OLDFILE} ]] && cat "${_OLDFILE}" >&${FD}
    cat << EOF >>&${FD}
# Enter the description for your Task
# Comments are ignored on output
EOF
    old_metadata=$(ls -li "$_TEMPFILE")
    "${VISUAL:-"${EDITOR:-vi}"}" "$_TEMPFILE" || return 1
    new_metadata=$(ls -li "$_TEMPFILE")
    if [ "$new_metadata" = "$old_metadata" ]; then
        # unchanged file, abandon operation
        return 0
    else
        awk -F'#' '{print $1}' "${_TEMPFILE}" >"${_OLDFILE}"
    fi
    exec ${FD} >&-
}

