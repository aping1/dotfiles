# === Profiling ===
#if I see that zsh takes to much time to load I profile what has been changed,
# I want to see my shell ready in not more than 1 second

PROFILE_STARTUP=true
[[ "${PROFILE_STARTUP}" == true ]] && zmodload zsh/zprof

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi
# Entirety of my startup file... then
if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

# === PATHS and EVNS 
# Location of my dotfiles
DOTFILES=$HOME/.dotfiles
DOTFILESDEPS=${DOTFILES:-$HOME}/deps

# === Setup PATH ===

if [[ "${OS_TYPE:="DARWIN"}" == "DARWIN" ]]; then
    path=(
        /opt/homebrew/bin
        /usr/local/{bin,sbin,opt}
        $path
    )
    export GOPATH=${HOME}/.go/bin

    # Brew for OSX
    if command -v brew &>/dev/null; then
        # Add to start of path
        path=(
            $(brew --prefix coreutils)/libexec/gnubin
            $(brew --prefix)/bin/
            $path
        )
    else
        echo "Install Homebrew" >&2
    fi

fi

# My posix paths
path=(
    $path
    ${DOTFILES}/scripts
    ${HOME}/bin
)

# Set the new path
typeset -U path

COMPLETION_WAITING_DOTS="true"


# === Shell Options ===
# Vim mode
bindkey -v
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export TERM="xterm-256color"


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
PROMT_SUBST=true
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@`hostname -f`"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh vi_mode virtualenv context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
# POWERLEVEL9K_DIR_BACKGROUND='238'
# POWERLEVEL9K_DIR_FOREGROUND='252'
POWERLEVEL9K_DIR_BACKGROUND='cyan'
POWERLEVEL9K_DIR_FOREGROUND='red'
POWERLEVEL9K_STATUS_BACKGROUND='238'
POWERLEVEL9K_STATUS_FOREGROUND='252'
POWERLEVEL9K_CONTEXT_BACKGROUND='240'
POWERLEVEL9K_CONTEXT_FOREGROUND='252'
POWERLEVEL9K_TIME_BACKGROUND='238'
POWERLEVEL9K_TIME_FOREGROUND='252'
POWERLEVEL9K_HISTORY_BACKGROUND='240'
POWERLEVEL9K_HISTORY_FOREGROUND='252'
POWERLEVEL9K_SHOW_CHANGESET=true
#POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_VCS_HG_HOOKS=scm-prompt
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='240'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='252'
POWERLEVER9k_VCS_ACTIONFORMAT_FOREGROUND='252'
POWERLEVER9k_VCS_ACTIONFORMAT_BACKGROUND='240'


#POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'


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

        # zgen prezto
        # zgen prezto editor key-bindings 'vi'
        # zgen prezto '*:*' color 'yes'
        # zgen prezto tmux:auto-start local 'yes'
        # zgen prezto '*:*' case-sensitive 'yes'
        # zgen prezto prompt theme 'off'
        # zgen prezto git
        # zgen prezto editor key-bindings 'vi'
        # zgen prezto command-not-found
        # zgen prezto tmux
        # zgen prezto fasd
        # zgen prezto history-substring-search
        # zgen prezto syntax-highlighting

        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
        # zgen oh-my-zsh plugins/bower
        zgen oh-my-zsh plugins/brew
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
        zgen oh-my-zsh plugins/vi-mode
        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/z
        zgen load unixorn/tumult.plugin.zsh
        zgen load zsh-users/zsh-history-substring-search
        zgen load zsh-users/zsh-syntax-highlighting
        zgen load zsh-users/zsh-autosuggestions
        # https://github.com/Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src

        # my own plugins each of these folders use init.zsh entry point
        zgen load $DOTFILES/plugins/aliases
        zgen load $DOTFILES/plugins/bootstrap
        zgen load $DOTFILES/plugins/dotfiles
        zgen load $DOTFILES/plugins/zpython
        zgen load $DOTFILES/plugins/pyenv
        zgen load $DOTFILES/plugins/fbtools
        zgen load $DOTFILES/plugins/direnv
        zgen load $DOTFILES/plugins/urltools
        zgen load $DOTFILES/plugins/tpm
        zgen load $DOTFILES/plugins/remote
        zgen load $DOTFILES/plugins/iterm2

        # load https://github.com/bhilburn/powerlevel9k theme for zsh
        zgen load bhilburn/powerlevel9k powerlevel9k.zsh-theme next

        # It takes control, so load last
        # zgen load $DOTFILES/plugins/my-tmux

        zgen save
    fi

    # Configure vundle
    vundle-init
fi

## === zsh Options ===
## Auto complete from anywhere in word
setopt COMPLETE_IN_WORD
## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP
## never ever beep ever
#setopt NO_BEEP
## automatically decide when to page a list of completions
#LISTMAX=0
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
#setopt ignoreeof
# Print the exit value of programs with non-zero exit status.
#setopt printexitvalue
#
#
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# load ls colors
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")

#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

# Powerline
#source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
#source /opt/homebrew/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
#
#===History Options===
# change the size of history files
export HISTSIZE=132768;
export HISTFILESIZE=$HISTSIZE
# skip over repeating histor
setopt HIST_FIND_NO_DUPS
# remove previosu commdn from history
# setopt HIST_IGNORE_ALL_DUPS 
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
# stage autocomlettion
export HIST_VERIFY

# sharing history between zsh processes
# and dont wait to write history
setopt INC_APPEND_HISTORY 
# setopt SHARE_HISTORY
# Do not share history
#setopt no_share_history
# Remove the history (fc -l) command from the history list when invoked.
# setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
# Store commented lines
setopt interactivecomments
#=== END History OPTIONS ===
export PATH="/usr/local/opt/ncurses/bin:$PATH"
