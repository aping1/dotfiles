#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors
source ~/.antigen.zsh

# Load various lib files
antigen bundle robbyrussell/oh-my-zsh lib/

#
# Antigen Theme
#

#
# Antigen Bundles
#

antigen-bundle vi-mode
antigen-bundle vundle

# Plugins
antigen bundle git  
antigen bundle tmuxinator
antigen bundle web-search  
antigen bundle command-not-found  
antigen bundle history  
antigen bundle zsh-users/zsh-syntax-highlighting  
antigen bundle jdavis/zsh-files  
#antigen bundle chrissicool/zsh-bash
#antigen bundle zsh-users/zsh-completions src
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle rupa/z

# Completions
antigen bundle zsh-users/zsh-completions src  
antigen bundle zsh-users/zsh-history-substring-search

# For SSH, starting ssh-agent is annoying
antigen bundle ssh-agent

# Python Plugins
antigen bundle pip
antigen bundle python
antigen bundle virtualenv
# OS specific plugins
if [[ $DISTRO == 'CentOS' ]]; then
#	antigen bundle centos
fi

antigen use oh-my-zsh
antigen bundle jdavis/zsh-files
antigen theme https://gist.github.com/3712874.git agnoster
# Secret info
# antigen bundle git@github.com:jdavis/secret.git
#
# OTHER STUFF

bindkey -v
export VISUAL=/usr/bin/vim
export EDITOR=/usr/bin/vim

## solarized midnight commander
# export MC_SKIN="$HOME/.mc/lib/solarized.ini"
#
antigen apply
strlen () {
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
}

# show right prompt with date ONLY when command is executed
preexec () {
    DATE=$( date +"[%H:%M:%S]" )
    local len_right=$( strlen "$DATE" )
    len_right=$(( $len_right+1 ))
    local right_start=$(($COLUMNS - $len_right))

    local len_cmd=$( strlen "$@" )
    local len_prompt=$(strlen "$PROMPT" )
    local len_left=$(($len_cmd+$len_prompt))

    RDATE="\033[${right_start}C ${DATE}"

    if [ $len_left -lt $right_start ]; then
        # command does not overwrite right prompt
        # ok to move up one line
        echo -e "\033[1A${RDATE}"
    else
        echo -e "${RDATE}"
    fi

}

_powerline_set_prompt ()
{
    local last_exit_code=$?;
    local jobnum="$(jobs -p|wc -l)";
    PS1="$(_powerline_prompt aboveleft $last_exit_code $jobnum)";
    if test -n "$POWERLINE_SHELL_CONTINUATION$POWERLINE_BASH_CONTINUATION"; then
        PS2="$(_powerline_local_prompt left -r.bash $last_exit_code $jobnum continuation)";
    fi;
    if test -n "$POWERLINE_SHELL_SELECT$POWERLINE_BASH_SELECT"; then
        PS3="$(_powerline_local_prompt left '' $last_exit_code $jobnum select)";
    fi;
    return $last_exit_code
}

PATH=$PATH:$HOME/bin
export PATH

# Initialization for FDK command line tools.Mon Aug 17 11:15:45 2015
FDK_EXE="/users/awampler3/bin/FDK/Tools/linux"
PATH=${PATH}:"/users/awampler3/bin/FDK/Tools/linux"
export PATH
export FDK_EXE
