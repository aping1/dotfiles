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
[[ -d "${DOTFILES}" ]] || git clone --recursive --branch feature/boostrap $HOME/dotfiles.git "${DOTFILES}"

DOTFILES_SOURCE=( $( find "${DOTFILES%/}" -iname dotfiles -type f) )
    cat ${DOTFILES_SOURCE[*]}   | sed  -n 's/\#.*$//g; /\(^brew\|^cask\|^tap\)/p;' | tr '"' \' > "${DOTFILES}/Brewfile" 
    if [[ ${#DOTFILES_SOURCE[*]} -ge 1 && -s "${DOTFILES}/Brewfile" ]] && brew bundle check --verbose --file "${DOTFILES}/Brewfile"; then
        brew bundle install --file "${DOTFILES}/Brewfile"
    else
        exit 2
    fi

cd

ln -sf ${DOTFILES}/.zprofile
ln -sf ${DOTFILES}/.zshrc
ln -sf ${DOTFILES}/.zsh_aliases 
mkdir -p .vim/autoload
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .vim/autoload

mkdir -p .config/nvim/autoload
ln -sf ${DOTFILES}/config/nvim/init.vim .config/nvim/
ln -sf ${DOTFILES}/config/nvim/iron.plugin.lua .config/nvim/
mkdir -p ${DOTFILES}/deps/vim-plug/plug.vim .config/nvim/autoload
ln -sf ${DOTFILES}/.gitconfig 
ln -sf ${DOTFILES}/ipython .config/
ln -s ${DOTFILES}/.zshenv 
mkdir .config/nvim/autoload
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .config/nvim/autoload
mkdir -p .vim/autoload 
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .vim/autoload
ln -sf ${DOTFILES}/.gitignore_global .gitignore
