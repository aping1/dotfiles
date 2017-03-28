#!/bin/zsh
#
setopt xtrace verbose
POWERLINE_VERSION="$(pip freeze | sed -n 's/\(powerline[-_]status\)==/powerline_status-/p')"
PYTHON_VERSION="$(python --version 2>&1 | tr -d ' ')"
PYTHON_VERSION="${PYTHON_VERSION:l}"
PYTHON_VERSION="${PYTHON_VERSION%.*}"
# TODO: make Darwin conditonal
DARWIN='/local'
POWERLINE_DIR="/usr${DARWIN}/lib/${PYTHON_VERSION}/site-packages/${POWERLINE_VERSION}-${PYTHON_VERSION:s/python/py}.egg/powerline"
#printf "POWERLINE_DIR: %s; POWERLINE_VERSION: %s;" ${POWERLINE_DIR} ${POWERLINE_VERSION}

if tmux has-session &>/dev/null; then
    [[ -f "${POWERLINE_DIR}/bindings/tmux/powerline.conf" ]] || return 2
    tmux source-file "${POWERLINE_DIR}/bindings/tmux/powerline.conf"
fi

unsetopt xtrace
