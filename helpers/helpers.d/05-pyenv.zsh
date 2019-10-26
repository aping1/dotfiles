#! /usr/bin/env zsh
# Python stuff
# if which brew && ! which pyenv 
# #     brew install pyenv pyenv-virtualenv
# # ln -s $(brew --cellar python)/* ~/.pyenv/versions/
# fi
export PYENV_ROOT=${PYENV_ROOT:=${HOME}/.pyenv/}
command -v pyenv > /dev/null && eval "$(pyenv init -)"
command -v pyenv-virtualenv-init > /dev/null && eval "$(pyenv virtualenv-init -)"

