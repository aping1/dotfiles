#! /usr/bin/env zsh
# Python stuff
# if which brew && ! which pyenv 
# #     brew install pyenv pyenv-virtualenv
# # ln -s $(brew --cellar python)/* ~/.pyenv/versions/
# fi
which pyenv > /dev/null && eval "$(pyenv init -)"
which pyenv-virtualenv-init > /dev/null && eval "$(pyenv virtualenv-init -)"

export PYENV_ROOT=${HOME}/.pyenv/
if whence pyenv &>/dev/null; then

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
fi
