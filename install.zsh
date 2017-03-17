#!/bin/zsh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
: "${DOTFILES=-"$HOME/.dotfiles"}"
[[ "${DOTFILES} -s "${SCRIPTPATH}" ]] || echo "Warning: Scriptpath \"${SCRIPTPATH}\" is not the same as Dotfile path: \"${DOTFILES\" 
export DOTFILES

# Change shell for current user to zsh
if [ ! "$SHELL" = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# remove old dot files
dotfiles='''~/.gitconfig
~/.gitignore_global
~/.tmux.conf
~/.vimrc
~/.zshrc
'''
tar cvzf ~/dotfile.backup.$(date '+%F').tar.gz ${dotfiles}
rm -rf ${dotfiles}

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
popd ${HOME}

for file in ${Sdotfiles}; then 
    ln -s "${DOTFILES}/$(basename $file)"
done


# Do special to sync sublime settings on OS X
if [[ "$OSTYPE" =~ "darwin" ]]; then
  rm ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

  ln -s ~/.dotfiles/settings/SublimeText/User      ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi

ln -s ${DOTFILES}/prezto "${ZDOTDIR:-$HOME}/.zprezto"


# install powerline fonts
~/.dotfiles/powerline-fonts/install.sh
