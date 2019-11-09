#!/bin/bash

export GOPATH="${HOME}/go"

export DOTFILES="$HOME/.dotfiles"
export DOTFILESDEPS="${DOTFILES}/deps/"
export PATH="${PATH}:${HOME}/bin:${DOTFILES}/bin"
export MANPATH="$PATH:${DOTFILES}/bin"
