# === Profiling ===


setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

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
    /usr/local/{bin,sbin,opt}
    $path
)
# Brew for OSX
if [[ "${DISTRO:="Darwin"}" == "Darwin" ]] && command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
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
export LANG=en_US.UTF-8
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
    source $HOME/.zgen/zgen.zsh
    if [[ ${ZGENRESET:-N} =~ ^[Yy]$ ]]; then
        zgen reset
    fi

    ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)
    # configure zgen
    if ! zgen saved; then

        zgen load denysdovhan/spaceship-prompt spaceship
        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
        zgen oh-my-zsh
        # zgen oh-my-zsh plugins/bower
        # zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/docker
        zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        zgen oh-my-zsh plugins/git-completion
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo
        zgen oh-my-zsh plugins/tmuxinator
        zgen oh-my-zsh plugins/terraform
        zgen oh-my-zsh plugins/urltools
        zgen oh-my-zsh plugins/vault
        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/fzf
        zgen oh-my-zsh plugins/kubectl
        zgen oh-my-zsh plugins/openssl



        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        #zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src

        # my own plugins each of these folders use init.zsh entry point
        zgen load ${DOTFILES}/plugins/aliases
        zgen load ${DOTFILES}/plugins/dotfiles
        zgen load ${DOTFILES}/plugins/pyenv
        zgen load ${DOTFILES}/plugins/fbtools
        # zgen load ${DOTFILES}/plugins/direnv
        zgen load ${DOTFILES}/plugins/urltools
        zgen load ${DOTFILES}/plugins/helpers
        zgen load ${DOTFILES}/plugins/autocomplete-extra
        # zgen load whiteinge/dotfiles /bin/diffconflicts master

        zgen oh-my-zsh plugins/vi-mode
        # async update vim mode

        # It takes control, so load last
        zgen load $DOTFILES/plugins/my-tmux

        zgen save
    fi

fi

# Bindkey ... autosuggest-*
# autosuggest-accept: Accepts the current suggestion.
# autosuggest-execute: Accepts and executes the current suggestion.
# autosuggest-clear: Clears the current suggestion.
# autosuggest-fetch: Fetches a suggestion (works even when suggestions are disabled).
# autosuggest-disable: Disables suggestions.
# autosuggest-enable: Re-enables suggestions.
# autosuggest-toggle: Toggles between enabled/disabled suggestions.

# -- Completion --------------
## Auto complete from anywhere in word
setopt COMPLETE_IN_WORD

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Red
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC="y"

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
# MAILCHECK=0

# additional configuration for zsh
# Remove the history (fc -l) command from the history list when invoked.
# setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
setopt histreduceblanks
setopt histverify
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
# setopt ignoreeof
# Print the exit value of programs with non-zero exit status.
# Do not share history
# if profiling was on

if ${PROFILING}; then
    zmodload zsh/zprof 
    zprof
fi

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Vim mode
bindkey -v

# Fuzzy Finder fzf with Ctrl-R
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Lines configured by zsh-newuser-install
setopt extendedglob nomatch
# End of lines configured by zsh-newuser-install
#
#export PYENV_ROOT="~/projects/virtualenvs"


if which setupsolarized &>/dev/null; then
setupsolarized dircolors.256dark
fi

autoload -Uz compinit && compinit -C

#export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'

SPACESHIP_PROMPT_ORDER=(
  # time        # Time stamps section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  # package     # Package version (Disabled)
  node          # Node.js section
  ruby          # Ruby section
  # elixir        # Elixir section
  # xcode       # Xcode section (Disabled)
  # swift         # Swift section
  golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia       # Julia section (Disabled)
  docker      # Docker section (Disabled)
  # aws           # Amazon Web Services section
  venv          # virtualenv section
  # conda         # conda virtualenv section
  pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember       # Ember.js section (Disabled)
  # kubecontext   # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  # vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
  )
