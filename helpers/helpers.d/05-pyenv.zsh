#! /usr/bin/env zsh
# Python stuff
# if which brew && ! which pyenv 
# #     brew install pyenv pyenv-virtualenv
# # ln -s $(brew --cellar python)/* ~/.pyenv/versions/
# fi
if (( $+commands[pyenv] )); then
    PATH="$(pyenv root)/shims:${PATH}"
    eval "$(pyenv init -)"
    (( $+commands[pyenv-virtualenv-init] )) && eval "$(pyenv virtualenv-init -)" || print -- 'Missed virtualenv-init' >&2
fi

