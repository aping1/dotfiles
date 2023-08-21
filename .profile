#!/bin/bash

export GOPATH="${HOME}/Library/go"

export DOTFILES="$HOME/.dotfiles"
export DOTFILESDEPS="${DOTFILES}/deps/"
export PATH="${PATH}:${HOME}/bin:${DOTFILES}/bin"
export PATH="/home/vagrant/node-v18.17.1-linux-x64/bin/:${PATH}"
export PATH="/usr/local/go/bin:${HOME}:${PATH}"
