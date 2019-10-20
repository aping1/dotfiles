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

export ZPLUG_HOME=${DOTFILES:="${HOME}/.dotfiles"}/deps/zplug

export DOTFILES
[[ ${DOTFILES:="~/.dotfiles"} ]] || exit 2
[[ -d "${DOTFILES}" ]] || git clone --recursive --branch master-pan file://$HOME/dotfiles.git "${DOTFILES}"

[[ -s ${ZPLUG_HOME}/init.zsh ]] || \
    ( cd ${DOTFILES} && git submodule init && git submodule update; ) &>/dev/null
[[ ${DOTFILES:="~/.dotfiles"} ]] || exit 2
[[ ${DOTFILES_GIT_REV} ]] || ( cd "${DOTFILES}" &>/dev/null && git check-ref-format "${DOTFILES_GIT_REV}" && git reset --head "${DOTFILES_GIT_REV}"; )

export DOTFILES_SOURCE=( $( find "${DOTFILES%/}" -iname dotfiles -type f) )
function brew_from_dotfiles () 
{
    [[ -d ${DOTFILES} ]] || return 1
    cat ${DOTFILES_SOURCE[*]} | awk '/^brew|^cask|^tap/{ gsub(/\#.*$/, "",$0);print; }' |  tr '"' "'" 
}

function bundle_install_dotfiles() 
{
    brew_from_dotfiles | tee  "${DOTFILES}/Brewfile"   || return 2
    [[ ${DEBUG:-} =~ ^[Yy][e][s]  && -s "${DOTFILES}/Brewfile" ]] \
        && cat "${DOTFILES}/Brewfile" \
        || return 2
    if [[ ${#DOTFILES_SOURCE[*]} -ge 1 && -s "${DOTFILES}/Brewfile" ]]; then
        brew bundle install --file=<(brew_from_dotfiles)
    else
        return 3
    fi
}

bundle_install_dotfiles

(
cd
ln -sf ${DOTFILES}/.zprofile
ln -sf ${DOTFILES}/.zshrc
ln -sf ${DOTFILES}/.zsh_aliases 
ln -sf ${DOTFILES}/.gitconfig 
ln -sf ${DOTFILES}/.gitignore_global .gitignore

# Vim 
mkdir -p .vim/autoload
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .vim/autoload

# NVIM
mkdir -p .config/nvim/autoload
ln -sf ${DOTFILES}/config/nvim/init.vim .config/nvim/
ln -sf ${DOTFILES}/config/nvim/iron.plugin.lua .config/nvim/

ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .config/nvim/autoload

# ipython
ln -sf ${DOTFILES}/ipython .config/
ln -s ${DOTFILES}/.zshenv 

) || echo "Failed to link"
