#!/bin/zsh
[[ "${PWD:A}"}" -ef "${HOME}" ]] || printf 'ERROR: pwd should be \${HOME} not \"%s\"' "${_REALPWD}"
unsetopt function_argzero
SCRIPT="${${(%):-%x}:A)"
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

mkdir ~/code ~/project
if [[ ! -d ./code/github.aping1.dotfiles ]] ; then
    git clone git@github.com:aping1/dotfiles.git "${DOTFILES}"
    exec ${DOTFILES}/install.sh
fi

FILES="""
    ${HOME}/.dotfiles     ./code/github.aping1.dotfiles
    ${HOME}/.gitignore_global ${DOTFILES}/.gitignore_global
    ${HOME}/.global_gitignore ${DOTFILES}/.global_gitignore
    ${HOME}/.antigen.zsh  ${DOTFILES}/.antigen.zsh
    ${HOME}/.bash_profile ${DOTFILES}/.bash_profile
    ${HOME}/.gdbinit      ${DOTFILES}/.gdbinit
    ${HOME}/.dircolors    ${DOTFILES}/dircolors
    ${HOME}/.tmux.conf    ${DOTFILES}/.tmux.conf
    ${HOME}/.ipython      ${DOTFILES}/.ipython
    ${HOME}/.vimrc        ${DOTFILES}/.vimrc
    ${HOME}/.zgen         ${DOTFILES}/deps/zgen
    ${HOME}/.zprezto      ${DOTFILES}/prezto
    ${HOME}/.zpreztorc    ${DOTFILES}/.zpreztorc
    ${HOME}/.zprofile     ${DOTFILES}/.zprofile
    ${HOME}/.zsh_aliases  ${DOTFILES}/.zsh_aliases
    ${HOME}/.zsh_aliasses ${DOTFILES}/.zsh_aliasses
    ${HOME}/.zshrc        ${DOTFILES}/.zshrc """

    # Create a tar for our backup
BACKUP_TAR="${DOFTILES}/backups/backup-$(date '%+F').tar"
if [[ ! -f ${BACKUP_TAR} ]]; then
    (
    _TEMP=$(mktemp  "BACKUPS.XXX")
    _cleanup() {
        rm $_TEMP
    }
    trap _cleanup EXIT SIGKILL
    mkdir -p $(dirname ${BACKUP_TAR})
    echo "#FILES" > ${TEMP}
    tar -cf ${BACKUP_TAR} ${TEMP}
    )
fi

while read HOME_LINK REAL_PATH; do
    if [[ -h ${HOME_LINE} ]] && ${HOME_LINK} -ef ${REAL_PATH} ]]; then
       :  # nothing
    elif [[ -e $HOME_LINK && ! -h ${HOME_LINK} ]]; then
       # File exists, save and kill it
       cmp --silent "${HOME_LINK}" "${REAL_PATH}" || tar -rf $BACKUP_TAR ${HOME_LINK}
       rm "${REAL_PATH}"
    elif [[ $(basename $HOME_LINE) -ef  $(basename $REAL_PATH) ]]; then
        # files are hard links, just kill it
        rm ${HOME_LINK}
    elif [[ -e ${HOME_LINK} ]]; then
       # save the file
       tar -rf $BACKUP_TAR ${HOME_LINK}
       rm -rf "${HOME_LINK}"
    fi
    ln -s $REAL_PATH
done <<< $FILES



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

"${DEPFILES}/fonts/install.sh"
ln -s "${HOME}/Library/Containers/com.hogbaysoftware.TaskPaper3/Data/Library/Application Support/TaskPaper/StyleSheets/solarized_walton.less" "${DOTFILES}/themes/TaskPaper/solarized_walton.less"
# this

# Steps for configuring automagically


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
