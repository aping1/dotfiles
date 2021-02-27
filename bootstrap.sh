#!/bin/bash
_trapped() {
    if [ $1 -gt 0 ]; then
       command -v zsh && exec zsh -l
       command -v bash && exec bash
       exec sh
    elif command -v zsh; then
        exec zsh -l
    elif command -v bash; then
        exec bash
    fi
    exit $1
}

trap '_trapped $?' EXIT 

 [[ -d "${DOTFILES:="~/.dotfiles"}" ]] &&  export DOTFILES || exit 2

# make sure deps exists
( 
cd "${DOTFILES}" 
git sumodule summary | grep -qE '^-' &>/dev/null && \
    git submodule init && git submodule update; 
) &>/dev/null

[[ ${DOTFILES_GIT_REV} ]] || ( 
    cd "${DOTFILES}" &>/dev/null \
        && git check-ref-format "${DOTFILES_GIT_REV}" \
        && git reset --head "${DOTFILES_GIT_REV}";
    )

declare -a DOTFILES_SOURCE
export DOTFILES_SOURCE=( "${DOTFILES}/dotfiles" )
if [[ -s "${DOTFILES}/${DISTRO:-posix}/dotfiles" ]]; then
    DOTFILES_SOURCE+=("${DOTFILES}/${DISTRO:-posix}/dotfiles")
fi

brew_from_dotfiles () 
{
    local src
    for src in "${DOTFILES_SOURCE[@]}"; do
        [[ -d $src ]] || return 1
    done
    awk '/^brew|^cask|^tap/{ gsub(/\#.*$/, "",$0); print; }' "${DOTFILES_SOURCE[@]}" |  tr '"' "'" 
}

bundle_install_dotfiles() 
{
    brew_from_dotfiles | tee  "${DOTFILES}/Brewfile"   || return 2
    if [[ ${DEBUG:-} =~ ^[Yy][e][s] ]]; then
        [[ -s "${DOTFILES}/Brewfile" ]] && cat "${DOTFILES}/Brewfile" \
        || return 2
    fi
    if [[ "${SKIP_BREW}" =~ ^[Yy](\|es$)\$ || "${#DOTFILES_SOURCE[@]}" -ge 1 ]]; then
        brew bundle install --file=<(
            brew_from_dotfiles | \
                tee >(awk '/^tap/{print $2}' | xargs -I'{}' -P100 -n1 brew tap '{}') >&2 | \
                tee >(awk '/^brew/{print $2}' | xargs -I'{}' -P100 -n1 brew fetch '{}') >&2
        )
        brew cleanup
    else
        return 3
    fi
}

bundle_install_dotfiles

function vim_deps_install() {
    # Standalone installer for Unixs
    # Original version is created by shoma2da
    # https://github.com/shoma2da/neobundle_installer

    emulate -L sh
    if [ $# -ne 1 ]; then
    echo "You must specify the installation directory!"
    return 1
    fi

    # Convert the installation directory to absolute path
    case $1 in
    /*) PLUGIN_DIR=$1;;
    *) PLUGIN_DIR=$PWD/$1;;
    esac
    INSTALL_DIR="${PLUGIN_DIR}/repos/github.com/Shougo/dein.vim"
    if [ -e "$INSTALL_DIR" ]; then
        echo "\"$INSTALL_DIR\" already exists!"
    else
        echo "Installing dein to \"$INSTALL_DIR\"..."
    fi
    # check git command
    command -v git || {
    echo 'Please install git or update your path to include the git executable!'
    return 1
    }

    # make plugin dir and fetch dein
    if ! [ -e "$INSTALL_DIR" ]; then
        mkdir -p "$PLUGIN_DIR"
        git clone https://github.com/Shougo/dein.vim "$INSTALL_DIR"
    fi
}

command -v zsh || return 1
vim_deps_install ~/.cache/dein

(
cd
ln -sf "${DOTFILES}/.profile"
ln -sf "${DOTFILES}/.zprofile"
ln -sf "${DOTFILES}/.zshrc"
ln -sf "${DOTFILES}/.zshenv"
ln -sf "${DOTFILES}/.zsh_aliases"
ln -sf "${DOTFILES}/.gitconfig"
ln -sf "${DOTFILES}/.gitignore_global" .gitignore
# Vim 
ln -sf ${DOTFILES}/.vimrc .vimrc
ln -sf ${DOTFILES}/.gitignore_global .gitignore

# NVIM
: ${XDG_CONFIG_HOME:="${HOME}/.config"}
ln -sf ${DOTFILES}/config/nvim/ ${XDG_CONFIG_HOME%/}/nvim 

# ipython
ln -sf ${DOTFILES}/ipython ${XDG_CONFIG_HOME}/ipython

) || echo "Failed to link"

exec zsh -lx "${HOME}/.dotfiles/install.zsh"

