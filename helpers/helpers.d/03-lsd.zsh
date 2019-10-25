#!/usr/bin/env zsh

if command -v lsd &>/dev/null; then
    alias ls='lsd' 
else
    alias ls='ls --color -G'
fi

