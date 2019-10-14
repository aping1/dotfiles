[[ -f ~/.zprofile ]] && source ~/.zprofile
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# === Profiling ===
if ${PROFILING}; then
    zmodload zsh/zprof 
    zprof
fi


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

# Homebrew
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments
# AUTOENV_FILE_ENTER=.env
# AUTOENV_HANDLE_LEAVE=1 # Turn on/off handling leaving an env
# AUTOENV_FILE_LEAVE=.envl

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

#P9K_VI_MODE_INSERT_FOREGROUND='teal'
if [[ -f "${ZPLUG_HOME:-"${HOME}/.zplug"}/init.zsh" ]]; then
    source "${ZPLUG_HOME}/init.zsh"

    declare -a DOTFILES_SOURCE=( "${DOTFILES%/}/"{,**/}dotfiles(.) )
    awk '/^brew|^cask|^tap/{print $1,$2}' ${DOTFILES_SOURCE[*]} | tr '"' \' | tee "${DOTFILES}/Brewfile"
    if [[ ${#DOTFILES_SOURCE[*]} -ge 1 ]] && brew bundle check --verbose --file "${DOTFILES}/Brewfile"; then
        printf "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
        if read -q ; then
            echo; brew bundle install --file="${DOTFILES}/Brewfile"
        fi
    fi

    zplug "denysdovhan/spaceship-prompt", from:github, as:theme

    export FZF_COMPLETION_TRIGGER='~~'

    # Options to fzf command
    export FZF_COMPLETION_OPTS='+c -x'
    zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*darwin*amd64*"

    # oh-my-zsh
    zplug "plugins/git",            from:oh-my-zsh
    zplug "plugins/docker",         from:oh-my-zsh
    zplug "plugins/docker", from:oh-my-zsh, if:'[[ $commands[docker] ]]'
    zplug "plugins/docker-compose", from:oh-my-zsh, if:'[[ $commands[docker-compose] ]]'
    zplug "plugins/git-extras",     from:oh-my-zsh
    zplug "plugins/gitignore",      from:oh-my-zsh
    zplug "plugins/git-completion", from:oh-my-zsh
    zplug "plugins/osx",            from:oh-my-zsh
    zplug "plugins/pip",            from:oh-my-zsh
    zplug "plugins/python",         from:oh-my-zsh
    zplug "plugins/sudo",           from:oh-my-zsh
    zplug "plugins/tmuxinator",     from:oh-my-zsh
    zplug "plugins/terraform",      from:oh-my-zsh, if:'[[ $commands[terraform] ]]'
    zplug "plugins/urltools",       from:oh-my-zsh
    zplug "plugins/vault",          from:oh-my-zsh,  if:'[[ $commands[vault] ]]'
    zplug "plugins/web-search",     from:oh-my-zsh
    zplug "plugins/fzf",            from:oh-my-zsh,  if:'[[ $commands[fzf] ]]'
    zplug "plugins/kubectl",        from:oh-my-zsh,  if:'[[ $commands[kubectl] ]]'
    zplug "plugins/openssl",        from:oh-my-zsh
    zplug "plugins/vi-mode",        from:oh-my-zsh, defer:1

    zplug "zsh-users/zsh-syntax-highlighting", from:github,     defer:2
    # https://github.com/Tarrasch/zsh-autoenv
    #zgen load Tarrasch/zsh-autoenv
    # https://github.com/zsh-users/zsh-completions
    zplug "zsh-users/zsh-completions",  from:github,             defer:2

                    # Person Plugings
                    #
    zplug "${DOTFILES}/plugins/fbtools", from:local,  use:"{tasks,projects,tmux}/*", as:command
    zplug "${DOTFILES}/plugins/helpers", from:local, as:command, use:"helpers.d/*.zsh"
# Use ~~ as the trigger sequence instead of the default **
# Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install New Plugins? [y/N]: "
        if read ; then
            echo; zplug install
        fi
    fi
    # Then, source plugins and add commands to $PATH
    zplug load --verbose
fi

# === Completion ===
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

## automatically decide when to page a list of completions
#LISTMAX=0

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Red
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC="y"

#
# === custumization ===
#
setopt extendedglob nomatch
## keep background processes at full speed
#setopt NOBGNICE
#setopt HUP
## never ever beep ever
#setopt NO_BEEP
## disable mail checking
# MAILCHECK=0
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
# setopt ignoreeof

# === history ===
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_BEEP
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# Remove the history (fc -l) command from the history list when invoked.
setopt histverify
# Print the exit value of programs with non-zero exit status.

# Fuzzy Finder fzf with Ctrl-R
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Vim mode
bindkey -v

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
# battery       # Battery level and status
vi_mode     # Vi-mode indicator (Disabled)
jobs          # Background jobs indicator
exit_code     # Exit code section
char          # Prompt character
)

# Man page colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
