#! /usr/bin/env zsh
# Python stuff

if whence pyenv &>/dev/null; then

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
fi
