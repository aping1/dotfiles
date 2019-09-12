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

# Shell
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
# This is one of examples why I want to keep my dotfiles private
#export HOMEBREW_GITHUB_API_TOKEN=MY_GITHUB_TOKEN
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoenv https://github.com/Tarrasch/zsh-autoenv
# Great plugin to automatically modify path when it sees .env file
# I use it for example to automatically setup docker/rbenv/pyenv environments

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
        zgen oh-my-zsh plugins/git-escape-magic

        # zgen load hchbaw/auto-fu.zsh
        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        zgen load Tarrasch/zsh-autoenv
        # https://github.com/zsh-users/zsh-completions
        zgen load zsh-users/zsh-completions src

        # my own plugins each of these folders use init.zsh entry point
        zgen load $DOTFILES/plugins/aliases
        zgen load $DOTFILES/plugins/dotfiles
        zgen load $DOTFILES/plugins/pyenv
        zgen load $DOTFILES/plugins/fbtools
        # zgen load $DOTFILES/plugins/autocomplete-extra
        # zgen load $DOTFILES/plugins/direnv
        zgen load $DOTFILES/plugins/urltools
        zgen load $DOTFILES/plugins/tpm

        # It takes control, so load last
        # zgen load $DOTFILES/plugins/tmux

        zgen save
    fi

fi
## zsh Option

## Auto complete from anywhere in word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

MAX_INT="$((X=(2**63)-1))"
if [[ "$((X=(2**32)-1))" -gt 0 && "$((X=2**64))" -lt 0 ]]; then
 MAX_INT="$((X=(2**32)-1))"
fi

HISTSIZE="${MAX_INT}"
HISTFILE=~/.zsh_history     #Where to save history to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
#setopt histnostore

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
setopt histreduceblanks
setopt histverify
# Do not exit on end-of-file (Ctrl-d). Require the use of exit or logout instead.
setopt ignoreeof
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
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")


[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

