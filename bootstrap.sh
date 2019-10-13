#!/bin/bash
_trapped() {
    if [ $1 -gt 0 ]; then
       command -v zsh && exec zsh -l
       exec sh
    elif command -v zsh; then
        exec zsh -l
    fi
    exit $1
}
trap '_trapped $?' EXIT 

git clone --recursive $HOME/dotfiles.git .dotfiles
cd $HOME/dotfiles.git && git remote -v | grep local && git remote add local file://$HOME/dotfiles.git || echo

export ZPLUG_HOME=${HOME}/.zplug
git clone https://github.com/zplug/zplug "${ZPLUG_HOME}"

