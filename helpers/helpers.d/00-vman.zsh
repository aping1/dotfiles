#! /usr/bin/env zsh
export PATH="$PATH:${XDG_CONFIG_HOME:-$HOME/.confi/nvim}/plugged/.nvim/vim-superman/bin"

if command -v vman &>/dev/null ; then
compdef vman="man"
# Completion
complete -o default -o nospace -F _man vman
fi
