
# === Shell ===
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# === Profiling ===
if [[ ${+PROFILING} -eq 1 ]]; then
    zmodload zsh/zprof 
    zprof
fi


# === zprofile if not autoloaded ===
[[ ${+ZPROFILE_LOADED} -eq 1 ]] \
    || source "${HOME}/.zprofile"

[[ ${+ZSH_ALIASES_LOADED} -eq 1 ]] \
    || source "${HOME}/.zsh_aliases"

# === PATHS and EVNS 
# Location of my dotfiles
DOTFILES=$HOME/.dotfiles
DOTFILESDEPS=${DOTFILES:-$HOME}/deps

# Standard path includes
path=(
    /usr/local/{bin,sbin,opt}
    $path
)
if command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
        $(brew --prefix)/bin/
        $path
    )
elif [[ "${DISTRO:="darwin"}" == "darwin" ]]; then
    # Auto install brew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Add dotfiles to end of path
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

# Homebrew
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments

[[ -f ~/.zprofile ]] && source ~/.zprofile
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Standard path includes
path=(
    /usr/local/{bin,sbin,opt}
    $path
)
# Brew for OSX
if command -v brew &>/dev/null; then
    # Add to start of path
    path=(
        $(brew --prefix coreutils)/libexec/gnubin
        $(brew --prefix python)/libexec/bin
        $(brew --prefix)/bin/
        $path
    )
elif [[ "${DISTRO:="darwin"}" == "darwin" ]]; then
    echo "Install Homebrew" >&2
    # add to end of path
fi

[[ ${DOTFILES} ]] && \
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

export ZPLUG_LOG_LOAD_FAILURE=1
if [[ -f "${ZPLUG_HOME:-"${HOME}/.zplug"}/init.zsh" ]]; then
    source "${ZPLUG_HOME}/init.zsh"

    zplug "denysdovhan/spaceship-prompt", from:github, as:theme

    zplug "junegunn/fzf-bin", \
        from:gh-r, \
        as:command, \
        rename-to:fzf, \
        use:"*darwin*amd64*"

    zplug 'zplug/zplug', hook-build:'zplug --self-manage' 

    zplug "dominictarr/JSON.sh", as:command, if:"(( ! $+commands[jq] ))", rename-to:jq
    # oh-my-zsh
    zplug "plugins/git",            as:plugin, from:oh-my-zsh
    zplug "plugins/docker",         as:plugin, from:oh-my-zsh
    zplug "plugins/docker", from:oh-my-zsh, if:'[[ $commands[docker] ]]'
    zplug "plugins/docker-compose", as:plugin, from:oh-my-zsh, if:'[[ $commands[docker-compose] ]]'
    zplug "plugins/git-extras",     as:plugin, from:oh-my-zsh
    zplug "plugins/gitignore",      as:plugin, from:oh-my-zsh
    zplug "plugins/git-completion", as:plugin, from:oh-my-zsh
    zplug "plugins/osx",            as:plugin, from:oh-my-zsh
    zplug "plugins/pip",            as:plugin, from:oh-my-zsh
    zplug "plugins/python",         as:plugin, from:oh-my-zsh
    zplug "plugins/sudo",           as:plugin, from:oh-my-zsh
    zplug "plugins/tmuxinator",     as:plugin, from:oh-my-zsh
    zplug "plugins/terraform",      as:plugin, from:oh-my-zsh, if:'[[ $commands[terraform] ]]'
    zplug "plugins/urltools",       as:plugin, from:oh-my-zsh
    zplug "plugins/vault",          as:plugin, from:oh-my-zsh,  if:'[[ $commands[vault] ]]'
    zplug "plugins/web-search",     as:plugin, from:oh-my-zsh
    zplug "plugins/fzf",            as:plugin, from:oh-my-zsh,  if:'[[ $commands[fzf] ]]'
    zplug "plugins/kubectl",        as:plugin, from:oh-my-zsh,  if:'[[ $commands[kubectl] ]]'
    zplug "plugins/openssl",        as:plugin, from:oh-my-zsh
    zplug "plugins/vi-mode",        as:plugin, from:oh-my-zsh, defer:1

    zplug "paulmelnikow/zsh-startup-timer"
    zplug "tysonwolker/iterm-tab-colors"
    zplug "desyncr/auto-ls"
    zplug "momo-lab/zsh-abbrev-alias"
    zplug "rawkode/zsh-docker-run"
    zplug "arzzen/calc.plugin.zsh"
    zplug "peterhurford/up.zsh"
    zplug "jimeh/zsh-peco-history"
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
        if read -q; then
            echo; zplug install
        fi
    fi
    # Then, source plugins and add commands to $PATH
    zplug load
fi

# === Fzf ===
# End of lines configured by zsh-newuser-install
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# === Completion ===
# Bindkey ... autosuggest-*
#   autosuggest-accept: Accepts the current suggestion.
#   autosuggest-execute: Accepts and executes the current suggestion.
#   autosuggest-clear: Clears the current suggestion.
#   autosuggest-fetch: Fetches a suggestion (works even when suggestions are disabled).
#   autosuggest-disable: Disables suggestions.
#   autosuggest-enable: Re-enables suggestions.
#   autosuggest-toggle: Toggles between enabled/disabled suggestions.

# Auto complete from anywhere in word
setopt COMPLETE_IN_WORD
# automatically decide when to page a list of completions
# LISTMAX=0

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline" # Red
export ZSH_AUTOSUGGEST_USE_ASYNC="y"

# === Customization ===
setopt extendedglob nomatch

# keep background processes at full speed
# setopt NOBGNICE
# setopt HUP

# === History ===
setopt APPEND_HISTORY
# sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
# dont run, show history expansion 
setopt histverify

# Vim mode
bindkey -v

