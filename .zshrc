#!/usr/bin/env zsh
# === Shell ===
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export MYPROMPT="${MYPROMPT:-spaceship-async}"

[[ ${+MACHINE_RC_LOADED} -eq 1 ]] \
    && printf -- 'Skipping: %s' "${HOME}/.machinerc" \
    || { [[ -f "${HOME}/.machinerc" ]] && source "${HOME}/.machinerc"; }

# === Profiling ===
if [[ ${+PROFILING} -eq 1 ]]; then
    zmodload zsh/zprof 
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# === zprofile if not autoloaded ===
[[ ${+ZPROFILE_LOADED} -eq 1 ]] \
    || source "${HOME}/.zprofile"

[[ ${+ZSH_ALIASES_LOADED} -eq 1 ]] \
    && printf -- 'Skipping: %s\n' "${HOME}/.zsh_aliases" \
    || source "${HOME}/.zsh_aliases"

# dumb terminal can be a vim dump terminal in that case don't try to load plugins
if [ ! $TERM = dumb ]; then
    ZGEN_AUTOLOAD_COMPINIT=true

    # If user is root it can have some issues with access to competition files
    if [[ "${USER}" == "root" ]]; then
        ZGEN_AUTOLOAD_COMPINIT=false
    fi

    # load zgen
    source "${DOTFILESDEPS:-"${HOME}"}/zgen/zgen.zsh"
    if [[ ${ZGENRESET:-N} =~ ^[Yy]$ ]]; then
        zgen reset
    fi

    if ! zgen saved; then
        # https://github.com/denysdovhan/spaceship-prompt
        # https://github.com/denysdovhan/spaceship-prompt/tree/master/docs
        zgen load denysdovhan/spaceship-prompt spaceship
        zgen load ${DOTFILES}/themes/spaceship

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh

        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/urltools

        # === Source mgmt ===
        zgen oh-my-zsh plugins/mecurial
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        zgen oh-my-zsh plugins/git-completion

        zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/cask
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/iterm2
        zgen oh-my-zsh plugins/emoji

        zgen oh-my-zsh plugins/docker
        zgen oh-my-zsh plugins/docker-compose
        zgen oh-my-zsh plugins/docker-machine
        zgen oh-my-zsh plugins/helm

        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo

        zgen oh-my-zsh plugins/terraform
        zgen oh-my-zsh plugins/vault
        zgen oh-my-zsh plugins/fzf

        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        # zgen load Tarrasch/zsh-autoenv
        zgen load zsh-users/zsh-completions src
        zgen load zsh-users/zsh-autosuggestions
        zgen load qoomon/zsh-lazyload

        # my own plugins each of these folders use init.zsh entry point
        zgen load ${DOTFILES}/plugins/fbtools
        zgen load ${DOTFILES}/plugins/helpers
        zgen load ${DOTFILES}/plugins/navigation
        zgen load ${DOTFILES}/plugins/autocomplete-extra
        # zgen load whiteinge/dotfiles /bin/diffconflicts master
        zgen oh-my-zsh plugins/vi-mode
        # async update vim mode
        # zgen load dritter/powerlevel9k powerlevel9k.zsh-theme async_all_the_segments

        zgen save
    fi

fi


# Transistion between vi states faster (default: 4)
KEYTIMEOUT=1

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
setopt COMPLETE_IN_WORD BRACE_CCL AUTO_PARAM_SLASH
export COMPLETION_WAITING_DOTS="true"

# automatically decide when to page a list of completions
# LISTMAX=0

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline" # Red
export ZSH_AUTOSUGGEST_USE_ASYNC="y"
(( $+ZSH_HIGHLIGHT_STYLES )) && \
export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'
# -- Completion --------------
## Auto complete from anywhere in word

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Red
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC="y"

# -- History --------------
# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
# setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_BEEP

# === Fzf ===
# End of lines configured by zsh-newuser-install
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_COMPLETION_TRIGGER='~~'
# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Setc Crtl+R to fzf
[[ ${FZF_BASE:="${HOME}/.fzf"} ]] && source "${FZF_BASE%/}/shell/key-bindings.zsh"

# === Customization ===
setopt extendedglob nomatch

# keep background processes at full speed
# setopt NOBGNICE
# setopt HUP

{
  # Compile zcompdump only if modified, to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Tear Down profiling
if (( $+PROFILING )); then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof
fi

