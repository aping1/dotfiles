#!/bin/zsh

unsetopt function_argzero
SCRIPT="$(realpath "${(%):-%x}")"
SCRIPTPATH="$(dirname "$SCRIPT")"
: "${DOTFILES:="$HOME/.dotfiles"}"
echo ${DOTFILES} ${SCRIPTPATH}
[[ -e ${DOTFILES} ]] || ln -s "${SCRIPTPATH}" "${DOTFILES}"
[[ "${DOTFILES}" -ef "${SCRIPTPATH}" ]] || printf "Warning: Scriptpath \"%s\" is not the same as Dotfile path: \"%s\"" "${SCRIPTPATH}" "${DOTFILES}" 
export DOTFILES

# Change shell for current user to zsh
if [[ ! "$SHELL" = "/bin/zsh" && ${CHANGESHELL:-N} =~ ^[Yy]$ ]]; then
  chsh -s /bin/zsh
fi

# remove old dot files
dotfiles='''.gitconfig .gitignore_global .tmux.conf .vimrc .zshrc .zprofile'''
old_dotfiles="$( for i in  $dotfiles; do [[ -f "${HOME}/$i" ]] && echo -n "${HOME}/$i"; done)"
[[ ${old_dotfiles} ]] && tar cvzf ~/dotfile.backup.$(date '+%F').tar.gz ${=old_dotfiles} && rm -r ${=dotfiles}

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
popd ${HOME}

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

"${DOTFILES}/fonts/install.sh"
