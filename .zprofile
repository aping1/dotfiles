#/usr/bin/env zsh
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# .zlogin is sourced on the start of a login shell. This file is often used to start X using startx. Some systems start X on boot, so this file is not always very useful.
# .zprofile is basically the same as .zlogin except that it's sourced directly before .zshrc is sourced instead of directly after it. According to the zsh documentation, ".zprofile is meant as an alternative to `.zlogin' for ksh fans; the two are not intended to be used together, although this could certainly be done if desired."
#
export ZPROFILE_LOADED


export TERM="xterm-256color"
export TERM="${TERM:-xterm}"
export LANG="en_US.UTF-8"
export LC_ALL="C.UTF-8"
export LC_CTYPE="C.UTF-8"

export DOTFILES="$HOME/.dotfiles"
export ZPLUG_HOME="$HOME/.dotfiles/deps/zplug"

case $(uname) in
  Darwin)
    # commands for OS X go here
    export DISTRO=darwin
  ;;
  Linux)
    # commands for Linux go here
    export DISTRO=linux
  ;;
  FreeBSD)
    # commands for FreeBSD go here
    export DISTO=bsd
  ;;
  *)
    # commands for Linux go here
    export DISTRO=posix
  ;;
esac
