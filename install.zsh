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

ln -s ${DOTFILES}/prezto "${ZDOTDIR:-$HOME}/.zprezto"


# TODO: Install vim-solarized8
# TODO: Install https://github.com/gabrielelana/awesome-terminal-fonts 
# TODO: Install .zpreztorc

# Font installd
# install powerline fonts
~/.dotfiles/powerline-fonts/install.sh
"${DEPFILES}/fonts/install.sh"

# Solarize Taskpaper
ln -s "${HOME}/Library/Containers/com.hogbaysoftware.TaskPaper3/Data/Library/Application Support/TaskPaper/StyleSheets/solarized_walton.less" "${DOTFILES}/themes/TaskPaper/solarized_walton.less"

# Insstall .chunkwm
install_chunkwm () {
    if which brew && chunkwm $(brew services list) =~ chunkwm ]] ; then
        brew tap crisidev/homebrew-chunkwm
        brew install chunkwm
    fi
    # /usr/local/opt/chunkwm/share/chunkwm/examples/chunkwmrc
    ln -s ${DOTFILES}/.chunkwmrc ${HOME}/.chunkwmrc
}
install_chunkwm

#if [[ $ZSH_IS_USED ]]; then
#    git clone https://github.com/zsh-users/antigen.git 03-github.zsh-users/antigen
#    ln -s ~/code/03-github.zsh-users.antigen/antigen ~/.antigen
#    git clone https://github.com/VundleVim/Vundle.vim.git 04-github.vundlevim.vundle/
#    mkdir -p ~/.vim/bundle/
#    ln -s ~/code/04-github.vundlevim.vundle/ ~/.vim/bundle/Vundle.vim
#    vim +BundleInstall +qall
#
#fi
#
#===
## Prezto config
#
#git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
#setopt EXTENDED_GLOB
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#   ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done
