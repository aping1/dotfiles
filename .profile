#!/bin/bash

export GOPATH="${HOME}/Library/go"

export DOTFILES="$HOME/.dotfiles"
export DOTFILESDEPS="${DOTFILES}/deps/"
export PATH="${PATH}:${HOME}/bin:${DOTFILES}/bin"
