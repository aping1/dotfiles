## === Profiling ===
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
path=(
    /usr/local/{bin,sbin}
    $DOTFILES/scripts
    ${HOME}/bin
    $path
)

# Brew for OSX
if [[ "${DISTRO}" == "Darwin" ]] && command -v brew &>/dev/null; then
path=(
    $(brew --prefix coreutils)/libexec/gnubin:${PATH}
    $(brew --prefix)/bin/:${PATH}
    $path
)
elif [[ "${DISTRO}" == "Darwin" ]]; then
    echo "Install Homebrew" >&2
fi
typeset -U path

COMPLETION_WAITING_DOTS="true"

# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;

# Shell
export CLICOLOR=1
export EDITOR='vim'
export PAGER='less'

# Homebrew
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments
AUTOENV_FILE_ENTER=.env
AUTOENV_HANDLE_LEAVE=1 # Turn on/off handling leaving an env
AUTOENV_FILE_LEAVE=.envl

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

# Powerlevel9k is the best theme for prompt, I like to keep it in dark gray colors
DEFAULT_USER=awampler
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_DIR_BACKGROUND='238'
POWERLEVEL9K_DIR_FOREGROUND='252'
POWERLEVEL9K_STATUS_BACKGROUND='238'
POWERLEVEL9K_STATUS_FOREGROUND='252'
POWERLEVEL9K_CONTEXT_BACKGROUND='240'
POWERLEVEL9K_CONTEXT_FOREGROUND='252'
POWERLEVEL9K_TIME_BACKGROUND='238'
POWERLEVEL9K_TIME_FOREGROUND='252'
POWERLEVEL9K_HISTORY_BACKGROUND='240'
POWERLEVEL9K_HISTORY_FOREGROUND='252'

# dumb terminal can be a vim dump terminal in that case don't try to load plugins
if [ ! $TERM = dumb ]; then
    ZGEN_AUTOLOAD_COMPINIT=true

    # If user is root it can have some issues with access to competition files
    if [[ "${USER}" == "root" ]]; then
        ZGEN_AUTOLOAD_COMPINIT=false
    fi

    # load zgen
    source $DOTFILESDEPS/zgen/zgen.zsh

    # configure zgen
    if ! zgen saved; then

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh

        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
        zgen oh-my-zsh plugins/bower
        zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/colored-man
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
        zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src

        # my own plugins
        zgen load $DOTFILES/plugins/aliases
        zgen load $DOTFILES/plugins/dotfiles
        zgen load $DOTFILES/plugins/zpython
        zgen load $DOTFILES/plugins/brew-helpers
        zgen load $DOTFILES/plugins/pyenv
        zgen load $DOTFILES/plugins/tpm

        # load https://github.com/bhilburn/powerlevel9k theme for zsh
        zgen load bhilburn/powerlevel9k powerlevel9k.zsh-theme

        # It takes control, so load last
        zgen load $DOTFILES/plugins/my-tmux

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
# if you want red dots to be displayed while waiting for completion

# additional configuration for zsh
# Remove the history (fc -l) command from the history list when invoked.
setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
setopt histreduceblanks
# Do not exit on end-of-file. Require the use of exit or logout instead.
#setopt ignoreeof
# Print the exit value of programs with non-zero exit status.
setopt printexitvalue
# Do not share history
setopt no_share_history

# if profiling was on
if $PROFILING; then
    zprof
fi
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Vim mode
bindkey -v
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")

TMUXINATOR='/Library/Ruby/Gems/2.0.0/gems/tmuxinator-0.8.1/completion/tmuxinator.zsh'

[[ -f $TMUXINATOR ]] && source ${TMUXINATOR} || echo "Warning: Could not instatiate tmuxinator"

set -o vi
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.4/site-packages"
