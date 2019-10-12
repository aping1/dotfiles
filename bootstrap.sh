#!/bin/bash
_trapped() {
    if [ $1 -gt 0 ]; then
        if command -v zsh; then
        exec zsh -l
    else
        exec sh
    fi
    fi
    exit $1
}
trap '_trapped $?' EXIT 
git clone --recurse-submodules file:///$HOME/dotfiles.git .dotfiles
