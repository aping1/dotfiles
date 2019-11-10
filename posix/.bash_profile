# /etc/skel/.bash_profile

[[ -f ~/.fbchef/environment ]] && source ~/.fbchef/environment

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -d ~/bin ]] && export PATH="$PATH:${HOME}/bin"
which vim &>/dev/null && export EDITOR='vim'
which vimpager &>/dev/null && export PAGER='vimpager'

export DOTFILES=$HOME/.dotfiles
export DOTFILESDEPS=${DOTFILES:-$HOME}/deps

# PYTHON INCLUDE
if which python3.5 &>/dev/null; then
    export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.5/site-packages"
elif which python3.6 &>/dev/null; then
    export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages"
fi

# Brew for OSX
if [[ "${DISTRO}" == "Darwin" ]] && command -v brew &>/dev/null; then
    PATH="${PATH}"/usr/local/{bin,sbin}":${DOTFILES}/scripts:${HOME}/bin"
    PATH="$(brew --prefix coreutils)/libexec/gnubin:${PATH}"
    PATH="$(brew --prefix)/bin/:${PATH}"
elif [[ "${DISTRO}" == "Darwin" ]]; then
    echo "Install Homebrew" >&2
fi

[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")

export FBANDROID_DIR=/Users/aping1/fbsource/fbandroid
alias quicklog_update=/Users/aping1/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

set -o vi
