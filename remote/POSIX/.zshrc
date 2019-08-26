# === Profiling ===
#if I see that zsh takes to much time to load I profile what has been changed,
# I want to see my shell ready in not more than 1 second
PROFILING=${PROFILING:-true}
if $PROFILING; then
    zmodload zsh/zprof
fi

# === PATHS and EVNS 
# Location of my dotfiles
DOTFILES=$HOME/.dotfiles
DOTFILESDEPS=${DOTFILES:-$HOME}/deps

# === Setup PATH ===
# My posix paths
path=(
    $path
    ${DOTFILES}/scripts
    ${HOME}/bin
)


# PYTHON INCLUDE
if which python3.5 &>/dev/null; then
    export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.5/site-packages"
elif which python3.6 &>/dev/null; then
    export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages"
fi

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

# === Shell Options ===
# Vim mode
bindkey -v
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export TERM="xterm-256color"

# tmux plugin settings
# this always starts tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTOQUIT=false

# Powerlevel9k is the best theme for prompt, I like to keep it in dark gray colors
export DEFAULT_USER=awampler
P9K_CONTEXT_TEMPLATE="%n@`hostname -f`"
P9K_PROMPT_ON_NEWLINE=true
P9K_LEFT_PROMPT_ELEMENTS=(ssh vi_mode virtualenv context dir vcs)
P9K_RIGHT_PROMPT_ELEMENTS=(status history time)
P9K_SHORTEN_DIR_LENGTH=3
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

        # list of plugins from zsh I use
        # see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
<<<<<<< HEAD
||||||| parent of d097df3... Add new working copy when connection tasks to a project
        zgen oh-my-zsh plugins/bower
=======
        # zgen oh-my-zsh plugins/bower
>>>>>>> d097df3... Add new working copy when connection tasks to a project
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
#===History Options===
# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
# sharing history between zsh processes
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# Do not share history
#setopt no_share_history
# Remove the history (fc -l) command from the history list when invoked.
# setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
setopt histreduceblanks
setopt histverify
#
# [[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# load ls colors
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which dircolors &> /dev/null && eval $(dircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")
[[ -f ${DOTFILES:-"~/.dotfiles"}/dircolors ]] && which gdircolors &> /dev/null && eval $(gdircolors "${DOTFILES:-"~/.dotfiles"}/dircolors")

#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

# Powerline
#source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
#source /opt/homebrew/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
#
