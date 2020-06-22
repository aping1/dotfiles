#! /usr/bin/env zsh

SUPERMANDIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged/vim-superman/bin"
if [[ -d ${SUPERMANDIR} ]]; then 
    export PATH="$PATH:${SUPERMANDIR}"
    if command -v vman &>/dev/null ; then
        alias man="vman"
        compdef vman="man"
        # Completion
        # complete -o default -o nospace -F _man vman
    fi
fi

