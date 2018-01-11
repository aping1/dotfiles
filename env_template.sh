#!/bin/bsah

# Current working dir
_SCRIPT_DIR="$( /usr/bin/cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -d ${_SCRIPT_DIR} ]] || printf "Could not find _SCRIPT_DIR %s\n" "${_SCRIPT_DIR}" >&2

# Current task name
# TODO: Check for change
_TASK_NAME="$(basename ${_SCRIPT_DIR:-"$(pwd)"})"
[[ ${_TASK_NAME} =~ ^([0-9]*)[:] ]] || _TASK_NAME=$(basename ${_TASK_NAME##*:})

# The task's venv
# We'll see if we have this already
_VENV_DIR="${_SCRIPT_DIR}/.venv-${_TASK_NAME}/"
[[ -f "${_SCRIPT_DIR}/.venv" && ${VENV_DIR} && -d "${VENV_DIR:-${_VENV_DIR}}" ]] && return 0

# Check for .venv delegate
if [[ -f "${_SCRIPT_DIR}/.venv" ]] && ! . "${_SCRIPT_DIR}/.venv"  ; then
   printf "ERROR: Failed to source .venv: %s\n" "$?" >&2
fi


######
# Setup VirtualEnv for task
# TODO: What if you change task ids? .env will regen
if [[ ${_TASK_NAME} && ! -f "${_SCRIPT_DIR}/.venv-${_TASK_NAME}/bin/activate" ]]; then 
    (
        /usr/bin/cd "${_SCRIPT_DIR}/"
        printf "Createing Virtual Envinronemt %s" "${_SCRIPT_DIR}/.venv-${_TASK_NAME}"
        if ! /opt/homebrew/bin/virtualenv ".venv-${_TASK_NAME}" &> /dev/null ; then 
            printf "ERROR: Unable to create Virtual env %s\n with %s" "${_SCRIPT_DIR}/.venv-${_TASK_NAME}" "$?" >&2
            return 1 
        fi
    )
else
    printf "Found Virtual Envinronemt %s\n" "${VENV_DIR}"
fi

if [[ ! -f "${_SCRIPT_DIR}/.venv" ]]; then
cat << _EOF > "${_SCRIPT_DIR}/.venv"
    #!/bin/bash
    export _SCRIPT_DIR="${_SCRIPT_DIR}"
    export TASK_NAME="${_TASK_NAME}"
    if [[ ! -f \${VENV_DIR:="${_VENV_DIR}"}/bin/activate ]]; then
        rm  .venv
        . "\${_SCRIPT_DIR}/.env" || return $?
    else
        . "\${VENV_DIR}/bin/activate" || return $?
    fi
    export VENV_DIR
    # this could go out of sync
    [[ \${VENV_DIR} =~ \${TASK_NAME} ]] && printf 'INFO: Reset TASK_NAME to %s' "\${TASK_NAME}" >&2 || printf 'WARNING: Task changed to %s\n' "\${TASK_NAME}" >&2
_EOF
fi

#TODO checksum this file
if ! . "${_SCRIPT_DIR}/.venv" ;then 
    printf "ERROR: Failed to generate .venv file %s\n" "$?" >&2
   # rm -f "${_SCRIPT_DIR}/.venv"  &>/dev/null
    return 1 
fi

