#!/bin/bash

# Author: Allison Wampler

# This is the script 

DEST_PLATFORM="${1}"

# -a autodetect dest platform
# -P pretend to sync. show what you're syncing
# -i include other files, directories in the transfer
# -d dotfiles path (default: $HOME/.dotfiles/remote)

for arg in $argv
case ${ARGS} in
    -a|--auto)
        echo 'copy all?'
        ;;

esac

case ${DEST_PLATFORM:=dumb} in
    dumb)
        # do something
        ;;
    Linux)
        # do linux
        ;;
    RHEL)
        # do rhel
        ;;
    Gentoo)

        ;;
    Darwin)
        # Do osx here
        ;;
    *)
        echo "${DEST_PLATFROM} is not an available remote"
        ;;
esac
