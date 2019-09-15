#!/usr/bin/env zsh
# Author: Allison Wanmpler <allison.wampler@apt-miss.com>

# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# .zshrc is for interactive shell configuration. You set options for the interactive shell there with the setopt and unsetopt commands. You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera. You also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).
## === Profiling ===
PROFILE_STARTUP="${PROFILING:-false}"
[[ "${PROFILE_STARTUP}" == true ]] && zmodload zsh/zprof

PROFILE_STARTUP=false
if [[ "${PROFILE_STARTUP}" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    setopt xtrace prompt_subst
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
typeset -U path

function is_osx() {
    [[ ${OSTYPE:-"$(uname -a)"} =~ [dD]arwin ]] || return 1
}

if is_osx && ! command -v 'brew' &>/dev/null then
    echo "Install Homebrew" >&2
fi

COMPLETION_WAITING_DOTS="true"

# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;


export HIST_IGNORE_ALL_DUPeS
export HIST_EXPIRE_DUPS_FIRST

# -- Shell --------------

export CLICOLOR=1

# set editor to the best vim we can find
if command -v 'nvim' &>/dev/null; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v 'vim' &>/dev/null; then
    export EDITOR='vim'
    export VISUAL='vim'
elif command -v 'vi' &>/dev/null; then
    export EDITOR='vim'
    export VISUAL='vi'
fi
export PAGER='less'

# Homebrew
# Autoenv https://github.com/Tarrasch/zsh-autoenv

# dumb terminal can be a vim dump terminal in that case don't try to load plugins
export TERM
if ! [[ "${TERM:=dumb}" == dumb ]]; then
    ZGEN_AUTOLOAD_COMPINIT=true

    # If user is root it can have some issues with access to competition files
    if [[ "${USER}" == "root" ]]; then
        ZGEN_AUTOLOAD_COMPINIT=false
    fi

    # load zgen
    [[ -x "${DOTFILESDEPS:-"${HOME}"}/zgen/zgen.zsh" ]] && \
        source ${DOTFILESDEPS:-"${HOME}"}/zgen/zgen.zsh

    # configure zgen
    if ! zgen saved; then

        # https://github.com/denysdovhan/spaceship-prompt
        # https://github.com/denysdovhan/spaceship-prompt/tree/master/docs
        zgen load denysdovhan/spaceship-prompt spaceship

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh
        # zgen oh-my-zsh plugins/bower
        zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo
        #zgen oh-my-zsh plugins/git-escape-magic

        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src
        zgen load zsh-users/zsh-autosuggestions

        # my own plugins each of these folders use init.zsh entry point
        zgen load $DOTFILES/plugins/aliases
        zgen load $DOTFILES/plugins/dotfiles
        zgen load $DOTFILES/plugins/pyenv
        zgen load $DOTFILES/plugins/fbtools
        # zgen load $DOTFILES/plugins/direnv
        zgen load $DOTFILES/plugins/urltools
        zgen load $DOTFILES/plugins/tpm
        # zgen load $DOTFILES/plugins/autocomplete-extra

        # It takes control, so load last
        # zgen load $DOTFILES/plugins/tmux

        zgen save
    fi

fi

# -- Completion --------------
## Auto complete from anywhere in word
setopt COMPLETE_IN_WORD

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,underline"

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

# -- History --------------

MAX_INT="$((X=(2**63)-1))"
if [[ "$((X=(2**32)-1))" -gt 0 && "$((X=2**64))" -lt 0 ]]; then
 MAX_INT="$((X=(2**32)-1))"
fi

HISTSIZE="${MAX_INT}"
# Where to save history to disk
HISTFILE=~/.zsh_history
# Erase duplicates in the history file
# HISTDUP=erase
# Append history to the history file (no overwriting)
setopt    appendhistory
# Share history across terminals
setopt    sharehistory
#Immediately append to the history file, not just when a term is killed
setopt    incappendhistory 
# setopt histignorespace
# setopt histnostore
## never ever beep ever
# setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
# MAILCHECK=0
# if you want red dots to be displayed while waiting for completion

# additional configuration for zsh
# Remove the history (fc -l) command from the history list when invoked.
# Remove superfluous blanks from each command line being added to the history list.
#setopt histreduceblanks
setopt histverify
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
setopt ignoreeof
# Print the exit value of programs with non-zero exit status.
# Do not share history
# if profiling was on
export ZSH_AUTOSUGGEST_USE_ASYNC="y"

if ${PROFILING}; then
    zmodload zsh/zprof 
    zprof
fi
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Vim mode
bindkey -v
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")


[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'


