# === Profiling ===
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#if I see that zsh takes to much time to load I profile what has been changed,
# I want to see my shell ready in not more than 1 second
PROFILING=${PROFILING:-false}
if $PROFILING; then
    zmodload zsh/zprof
fi

# === PATHS and EVNS 
# Location of my dotfiles

DOTFILES=$HOME/.dotfiles
DOTFILESDEPS=${DOTFILES:-$HOME}/deps

## Setup PATH
# Standard path includes

# # PYTHON INCLUDE
# if which python3.5 &>/dev/null; then
#     export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.5/site-packages"
# elif which python3.6 &>/dev/null; then
#     export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages"
# fi

path=(
    /usr/local/{bin,sbin,opt}
    $path
)
# Brew for OSX
if [[ "${DISTRO:="Darwin"}" == "Darwin" ]] && command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix)/bin/
        $path
    )
elif [[ "${DISTRO:="Darwin"}" == "Darwin" ]]; then
    echo "Install Homebrew" >&2
    # add to end of path
fi

path=(
    $path
    ${DOTFILES}/scripts
    ${HOME}/bin
)

typeset -U path

COMPLETION_WAITING_DOTS="true"

# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;

# Shell
export CLICOLOR=1
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

export TERM="xterm-256color"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64

# Homebrew
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments
#AUTOENV_FILE_ENTER=.env
#AUTOENV_HANDLE_LEAVE=1 # Turn on/off handling leaving an env
#AUTOENV_FILE_LEAVE=.envl

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

# Powerlevel9k is the best theme for prompt, I like to keep it in dark gray colors
export DEFAULT_USER=awampler
P9K_CONTEXT_TEMPLATE="%n@$(hostname -s)"
P9K_PROMPT_ON_NEWLINE=true
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
P9K_LEFT_PROMPT_ELEMENTS=(host ssh user dir dir_writable vcs newline vi_mode pyenv )
P9K_RPROMPT_ON_NEWLINE=true
P9K_RIGHT_PROMPT_ELEMENTS=(status history time)
P9K_DIR_SHORTEN_LENGTH=35
P9K_DIR_BACKGROUND='238'
P9K_DIR_FOREGROUND='252'
P9K_STATUS_BACKGROUND='238'
P9K_STATUS_FOREGROUND='252'
P9K_CONTEXT_BACKGROUND='240'
P9K_CONTEXT_FOREGROUND='252'
P9K_TIME_BACKGROUND='238'
P9K_TIME_FOREGROUND='252'
P9K_HISTORY_BACKGROUND='240'
P9K_HISTORY_FOREGROUND='252'
#P9K_VI_MODE_INSERT_FOREGROUND='teal'


# dumb terminal can be a vim dump terminal in that case don't try to load plugins
if [ ! $TERM = dumb ]; then
    ZGEN_AUTOLOAD_COMPINIT=true

    # If user is root it can have some issues with access to competition files
    if [[ "${USER}" == "root" ]]; then
        ZGEN_AUTOLOAD_COMPINIT=false
    fi

    # load zgen
    source $DOTFILESDEPS/zgen/zgen.zsh
    if [[ ${ZGENRESET:-N} =~ ^[Yy]$ ]]; then
        zgen reset
    fi

    # configure zgen
    if ! zgen saved; then

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh

        zgen prezto
        zgen prezto editor key-bindings 'vi'
        zgen prezto '*:*' color 'yes'
        # zgen prezto tmux:auto-start local 'yes'
        zgen prezto '*:*' case-sensitive 'yes'
        zgen prezto prompt theme 'off'
        zgen prezto git
        zgen prezto tmux
        zgen prezto fasd
        zgen prezto history-substring-search
        zgen prezto syntax-highlighting

        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
        # zgen oh-my-zsh plugins/bower
        # zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo
        zgen oh-my-zsh plugins/tmuxinator
        zgen oh-my-zsh plugins/urltools
        zgen oh-my-zsh plugins/vundle
        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/z

        # https://github.com/Tarrasch/zsh-autoenv
        #zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src

        # my own plugins each of these folders use init.zsh entry point
        zgen load $DOTFILES/plugins/aliases
        zgen load $DOTFILES/plugins/bootstrap
        zgen load $DOTFILES/plugins/dotfiles
        zgen load $DOTFILES/plugins/zpython
        zgen load $DOTFILES/plugins/pyenv
        zgen load $DOTFILES/plugins/fbtools
        # zgen load $DOTFILES/plugins/direnv
        zgen load $DOTFILES/plugins/urltools
        zgen load $DOTFILES/plugins/tpm
        zgen load $DOTFILES/helpers

        zgen oh-my-zsh plugins/vi-mode
        zgen load denysdovhan/spaceship-prompt spaceship

        zgen save
    fi

    # Configure vundle
    vundle-init
fi

# specific for machine configuration, which I don't sync
if [ -f ~/.machinerc ]; then
    source ~/.machinerc
fi

## zsh Option

## Auto complete from anywhere in word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0
# if you want red dots to be displayed while waiting for completion

# additional configuration for zsh
# Remove the history (fc -l) command from the history list when invoked.
# setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
setopt histreduceblanks
setopt histverify
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
# setopt ignoreeof
# Print the exit value of programs with non-zero exit status.
# setopt printexitvalue
# Do not share history
# setopt no_share_history
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Vim mode
bindkey -v
# set -o vi
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")

# TMUXINATOR='/Library/Ruby/Gems/2.0.0/gems/tmuxinator-0.8.1/completion/tmuxinator.zsh'
# [[ -f $TMUXINATOR ]] && source ${TMUXINATOR} || echo "Warning: Could not instatiate tmuxinator"


#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

# Powerline
#source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
#source /opt/homebrew/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
#source /opt/homebrew/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
#
# Fix 
#TRAPWINCH() {
#    zle && zle .reset-prompt && zle -R
#}
bindkey -v
export FBANDROID_DIR=/Users/aping1/fbsource/fbandroid
alias quicklog_update=/Users/aping1/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

# Lines configured by zsh-newuser-install
setopt extendedglob nomatch
# End of lines configured by zsh-newuser-install
#
#export PYENV_ROOT="~/projects/virtualenvs"

export PYENV_ROOT=/Users/aping1/.pyenv/
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

alias vim=nvim

#Basic colors
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

