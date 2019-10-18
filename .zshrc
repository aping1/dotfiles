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
        if read -q; then
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

#Basic colors
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


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
