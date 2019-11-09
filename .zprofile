#!/usr/bin/env zsh
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# .zlogin is sourced on the start of a login shell. This file is often used to start X using startx. Some systems start X on boot, so this file is not always very useful.
# .zprofile is basically the same as .zlogin except that it's sourced directly before .zshrc is sourced instead of directly after it. According to the zsh documentation, ".zprofile is meant as an alternative to `.zlogin' for ksh fans; the two are not intended to be used together, although this could certainly be done if desired."
#
export ZPROFILE_LOADED

[[ -f ~/.profile ]] && source "${HOME}/.profile"

# === PATHS and EVNS 
# Location of my dotfiles

# Standard path includes
path=(
    /usr/local/{bin,sbin}
    ${HOME}/bin
    $path
)
typeset -U path

if [[ -d "${DOTFILES}" ]]; then 
    path=(
        $path
        ${DOTFILES}/scripts
    )
	typeset -U path
fi

if (( $+command[brew] )) ; then
    # Add to start of path
    brew_prefix=$(brew --prefix)
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
        ${brew_prefix}/bin/
        $path
    )
    manpath=(
        ${brew_prefix}/share/man/man*
        $manpath
    )
elif [[ "${DISTRO:="darwin"}" == "darwin" && ! -x /usr/local/bin/brew ]]; then
    printf -- "Install Homebrew" >&2
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

export DOTFILES="$HOME/.dotfiles"

export TERM="xterm-256color"
export TERM="${TERM:-xterm}"

export FZF_BASE="${HOME}/.fzf"

if (( $+command[uname] )); then
    export DISTRO=unknown
else
    case $(uname) in
    Darwin)
        # commands for OS X go here
        export DISTRO=darwin
        export LANG="en_US.UTF-8"
        export LC_ALL="en_US.UTF-8"
        export LC_CTYPE="en_US.UTF-8"
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
        export LANG="C.UTF-8"
        export LC_ALL="C.UTF-8"
        export LC_CTYPE="C.UTF-8"
    ;;
    esac
fi
