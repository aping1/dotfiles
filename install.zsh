#!/bin/zsh
[[ "${_REALPWD="$(realpath ${PWD})"}" == "$(realpath ${HOME})" ]] || printf 'ERROR: pwd should be \${HOME} not \"%s\"' "${_REALPWD}"
unsetopt function_argzero
SCRIPT="$(realpath "${(%):-%x}")"
SCRIPTPATH="$(dirname "$SCRIPT")"
: "${DOTFILES:="$HOME/.dotfiles"}"
: "${DEPFILES:="$HOME/.dotfiles/deps"}"

ln -s "${DEPFILES}/zgen" "${HOME}/.zgen"
mkdir -p $HOME/.config/
ln -s "${DOTFILES}/powerline_config" ".config/powerline"

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
pushd ${HOME}

for file in ${=dotfiles}; do 
    ln -s "${DOTFILES}/$(basename $file)" &>/dev/null && printf 'Created Link for \"%s\"' "${file}"
done


# Do special to sync sublime settings on OS X
if [[ "$OSTYPE" =~ "darwin" && -d '~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User' ]]; then
  rm ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  ln -s ~/.dotfiles/settings/SublimeText/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi

ln -s ${DOTFILES}/prezto "${ZDOTDIR:-$HOME}/.zprezto"

# install powerline fonts
~/.dotfiles/powerline-fonts/install.sh

# TODO: Install vim-solarized8
# TODO: Install https://github.com/gabrielelana/awesome-terminal-fonts 
# TODO: Install .zpreztorc

"${DEPFILES}/fonts/install.sh"
ln -s "${HOME}/Library/Containers/com.hogbaysoftware.TaskPaper3/Data/Library/Application Support/TaskPaper/StyleSheets/solarized_walton.less" "${DOTFILES}/themes/TaskPaper/solarized_walton.less"

