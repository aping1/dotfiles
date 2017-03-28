#!/bin/zsh

unsetopt function_argzero
SCRIPT="$(realpath "${(%):-%x}")"
SCRIPTPATH="$(dirname "$SCRIPT")"
: "${DOTFILES:="$HOME/.dotfiles"}"
printf "DOTFILES: %s; SCRIPTPATH: %s" "${DOTFILES}" "${SCRIPTPATH}"
[[ -e ${DOTFILES} ]] || ln -s "${SCRIPTPATH}" "${DOTFILES}"
[[ "${DOTFILES}" -ef "${SCRIPTPATH}" ]] || printf "Warning: Scriptpath \"%s\" is not the same as Dotfile path: \"%s\"" "${SCRIPTPATH}" "${DOTFILES}" 
export DOTFILES

# Change shell for current user to zsh
if [[ ! "$SHELL" = "/bin/zsh" && ${CHANGESHELL:-N} =~ ^[Yy]$ ]]; then
  chsh -s /bin/zsh
fi

# remove old dot files
<<<<<<< HEAD
dotfiles='''~/.gitconfig
~/.gitignore_global
~/.tmux.conf
~/.vimrc
~/.zshrc
~/.zpreztorc
'''

tar cvzf ~/dotfile.backup.$(date '+%F').tar.gz ${dotfiles}
rsync -a .tmux ~/.dotfiles/tmux && rm -rf ~/.tmux || { echo "Cannot finish installed tmux sync" && return; }
rsync -a ~/.vim ~/.dotfiles/vim && rm -rf ~/.vim || { echo "Cannot finish installed vim sync" && return; }
dotfiles='''.gitconfig .gitignore_global .tmux.conf .vimrc .zshrc .zprofile'''
old_dotfiles="$( for i in  $dotfiles; do [[ -f "${HOME}/$i" ]] && echo -n "${HOME}/$i"; done)"
[[ ${old_dotfiles} ]] && tar cvzf ~/dotfile.backup.$(date '+%F').tar.gz ${=old_dotfiles} && rm -r ${=dotfiles}


mkdir -p .tmux
mkdir -p .vim/bundle
ln -s "${DOTFILES}/deps/Vundle.vim" ".vim/bundle/"
vim +BundleInstall +qall &>/dev/null

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
pushd ${HOME}

for file in ${=dotfiles}; do 
    ln -s "${DOTFILES}/$(basename $file)"
done


# Do special to sync sublime settings on OS X
if [[ "$OSTYPE" =~ "darwin" ]]; then
  rm ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  ln -s ~/.dotfiles/settings/SublimeText/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi

ln -s ${DOTFILES}/prezto "${ZDOTDIR:-$HOME}/.zprezto"

# install powerline fonts
~/.dotfiles/powerline-fonts/install.sh

# TODO: Install vim-solarized8
# TODO: Install https://github.com/gabrielelana/awesome-terminal-fonts 
# TODO: Install .zpreztorc

"${DOTFILES}/fonts/install.sh"
