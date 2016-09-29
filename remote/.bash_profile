# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

[[ -d ~/bin ]] && export PATH="$PATH:${HOME}/bin"
set -o vi
which vim &>/dev/null && export EDITOR='vim'
