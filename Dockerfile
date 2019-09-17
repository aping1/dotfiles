
FROM alpine:3.7
RUN apk add --no-cache git zsh

VOLUME ["$HOME/repos/dotfiles"]
run git clone file://$HOME/repos/dotfiles

copy . .dotfiles/

WORKDIR .dotfiles
cmd zsh --trace ./install.zsh
entrypoint /bin/bash

