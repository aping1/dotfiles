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

cd

ln -sf ${DOTFILES}/.zprofile
ln -sf ${DOTFILES}/.zshrc
ln -sf ${DOTFILES}/.zsh_aliases 
mkdir -p .config/nvim
ln -sf ${DOTFILES}/config/nvim/init.vim .config/nvim/
ln -sf ${DOTFILES}/config/nvim/iron.plugin.lua .config/nvim/
ln -sf ${DOTFILES}/.gitconfig 
ln -sf ${DOTFILES}/ipython .config/
mkdir .config/nvim/autoload
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .config/nvim/autoload
mkdir -p .vim/autoload 
ln -sf ${DOTFILES}/deps/vim-plug/plug.vim .vim/autoload

exec zsh

