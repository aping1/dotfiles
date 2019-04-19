# 
# function use_editor () {
#     : ${_OLDFILE:=${1:-${OLDFILE}}}
#     : ${_TEMPFILE:="$(mktemp /tmp/.XXXXXXXXXX)"}
#     [[ -f ${_TEMPFILE} ]] || return 3
#     exec 3<${_TEMPFILE}
#     [[ -s ${_OLDFILE} ]] && cat "${_OLDFILE}" >&3
#     cat << EOF >>&3
# # Enter the description for your Task
# # Comments are ignored on output
# EOF
#     old_metadata=$(ls -li "$_TEMPFILE")
#     "${VISUAL:-"${EDITOR:-vi}"}" "$_TEMPFILE" || return 1
#     new_metadata=$(ls -li "$_TEMPFILE")
#     if [ "$new_metadata" = "$old_metadata" ]; then
#         # unchanged file, abandon operation
#         return 0
#     else
#         awk -F'#' '{print $1}' "${_TEMPFILE}" >"${_OLDFILE}"
#     fi
#     exec 3>&-
# }
# 
function direnv_layout_dir () {
    echo "${direnv_layout_dir:-"$PWD/.env"}"
}

function _fb_helper_util_layout_python() {
  local python=${1:-python} ENV_COMMENT
  [[ $# -gt 0 ]] && shift
  if ! [[ $python =~ ^python ]]; then
      ENV_COMMENT=$python
      python="python3"
  fi
  if [[ ${ENV_COMMENT:=${1}} ]]; then
      [[ $# -gt 0 ]] && shift
  fi
  local old_env=$(direnv_layout_dir)/virtualenv
  unset PYTHONHOME
  if [[ -d $old_env ]]; then
    export VIRTUAL_ENV=$old_env
  else
    local python_version
    python_version=$("$python" -c "import platform as p;print(p.python_version())")
    if [[ -z $python_version ]]; then
      log_error "Could not find python's version"
      return 1
    fi
    export VIRTUAL_ENV=$(direnv_layout_dir)/venv/$python_version-${ENV_COMMENT:-None}
    if [[ ! -d $VIRTUAL_ENV ]]; then
      virtualenv "--python=$python" "$@" "$VIRTUAL_ENV"
    fi
  fi

}


