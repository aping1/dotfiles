#!/bin/bash

export GOPATH="${HOME}/Library/go"

export DOTFILES="$HOME/.dotfiles"
export DOTFILESDEPS="${DOTFILES}/deps/"
export PATH="${PATH}:${HOME}/bin:${DOTFILES}/bin"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/awampler/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
