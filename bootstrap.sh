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
# Clone if not a directory
[[ -d "${DOTFILES}" ]] || git clone --recursive --branch master file://$HOME/dotfiles.git "${DOTFILES}"

# make sure deps exists
( 
cd ${DOTFILES} 
git sumodule summary | grep -qE '^-' &>/dev/null && \
    git submodule init && git submodule update; 
) &>/dev/null
[[ ${DOTFILES:="~/.dotfiles"} ]] || exit 2
[[ ${DOTFILES_GIT_REV} ]] || ( cd "${DOTFILES}" &>/dev/null && git check-ref-format "${DOTFILES_GIT_REV}" && git reset --head "${DOTFILES_GIT_REV}"; )

export DOTFILES_SOURCE=( ${DOTFILES}/dotfiles ${DOTFILES}/${DISTRO:-posix}/dotfiles )

function brew_from_dotfiles () 
{
    [[ -d ${DOTFILES} ]] || return 1
    cat ${DOTFILES_SOURCE[*]} | awk '/^brew|^cask|^tap/{ gsub(/\#.*$/, "",$0); print; }' |  tr '"' "'" 
}

function bundle_install_dotfiles() 
{
    brew_from_dotfiles | tee  "${DOTFILES}/Brewfile"   || return 2
    if [[ ${DEBUG:-} =~ ^[Yy][e][s] ]]; then
        [[ -s "${DOTFILES}/Brewfile" ]] && cat "${DOTFILES}/Brewfile" \
        || return 2
    fi
    if [[ ${#DOTFILES_SOURCE[*]} -ge 1 ]]; then
        # Parrallel fetch to speed it up
        brew_from_dotfiles | awk '/^brew/{print $2}' | xargs -I'{}' -P100 -n1 brew fetch '{}'
        brew bundle install --file=<(brew_from_dotfiles)
        brew cleanup
    else
        return 3
    fi
}

bundle_install_dotfiles

command -v zsh || return 1

(
cd
ln -sf ${DOTFILES}/.zprofile
ln -sf ${DOTFILES}/.zshrc
ln -sf ${DOTFILES}/.zsh_aliases 
ln -sf ${DOTFILES}/.gitconfig 
ln -sf ${DOTFILES}/.gitignore_global .gitignore

# Vim 
mkdir -p .vim/autoload
ln -sf ${DOTFILES}/.vimrc
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .vim/autoload
ln -sf ${DOTFILES}/.gitignore_global .gitignore


# NVIM
mkdir -p .config/nvim/autoload
ln -sf ${DOTFILES}/config/nvim/init.vim .config/nvim/
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .config/nvim/autoload

# ipython
ln -sf ${DOTFILES}/ipython .config/
ln -s ${DOTFILES}/.zshenv 
)
exec zsh -lx "${HOME}/.dotfiles/install.zsh"
