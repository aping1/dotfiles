#!/usr/bin/local/zsh
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# Since .zshenv is always sourced, it often contains exported variables that should be available to other programs. For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv. Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.
# === PATHS and EVNS 
# Location of my dotfiles

# Standard path includes
export ZSHENV
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

function setup_brew_env () {
    # Add to start of path
    brew_prefix=$(brew --prefix)
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        ${brew_prefix}/bin/
        $path
    )
	typeset -U path
}

function setup_man_path () {
    manpath=(
        ${brew_prefix}/share/man/man*
        $manpath
    )
	typeset -U manpath
}

export DOTFILES="$HOME/.dotfiles"
