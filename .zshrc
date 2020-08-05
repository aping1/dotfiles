#!/usr/bin/env zsh
#b
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
        # zgen load denysdovhan/spaceship-prompt spaceship
        # zgen load ${DOTFILES}/themes/spaceship
-        zgen load romkatv/powerlevel10k powerlevel10k
-        zgen load $DOTFILES/themes/p10k

        # zgen will load oh-my-zsh and download it if required
        zgen oh-my-zsh

        zgen oh-my-zsh plugins/web-search
        zgen oh-my-zsh plugins/urltools

        # === Source mgmt ===
        # depricated?
        # zgen oh-my-zsh plugins/mecurial
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/gitfast
        # zgen oh-my-zsh plugins/git-extras
        zgen oh-my-zsh plugins/gitignore
        # depricated
        # zgen oh-my-zsh plugins/git-completion
        zgen oh-my-zsh plugins/npm

        zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/osx
        zgen oh-my-zsh plugins/iterm2
        zgen oh-my-zsh plugins/emoji
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

        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/sudo

        zgen load zsh-users/zsh-syntax-highlighting
        # https://github.com/Tarrasch/zsh-autoenv
        # zgen load Tarrasch/zsh-autoenv
        zgen load zsh-users/zsh-completions src
        zgen load zsh-users/zsh-autosuggestions
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
setopt COMPLETE_IN_WORD BRACE_CCL AUTO_PARAM_SLASH GLOBCOMPLETE
setopt globcomplete globsubst
export COMPLETION_WAITING_DOTS="true"

# automatically decide when to page a list of completions
# LISTMAX=0

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
(( $+ZSH_HIGHLIGHT_STYLES )) && \
export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'
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

# see https://invisible-island.net/xterm/terminfo-contents.html#tic-xterm-r6
# https://www.ibm.com/support/knowledgecenter/en/ssw_aix_71/filesreference/terminfo.html
    typeset -A key
    key=(
        BackSpace  "${terminfo[kbs]}"
        Home       "${terminfo[khome]}"
        End        "${terminfo[kend]}"
        Insert     "${terminfo[kich1]}"
        Delete     "${terminfo[kdch1]}"
        Up         "${terminfo[kcuu1]}"
        Down       "${terminfo[kcud1]}"
        Left       "${terminfo[kcub1]}"
        Right      "${terminfo[kcuf1]}"
        PageUp     "${terminfo[kpp]}"
        PageDown   "${terminfo[knp]}"
        BackTab    "${terminfo[kcbt]}"
    )

bindkey "${terminfo[kcbt]}" up-line-or-history
# bindkey -M autosuggest-fetch '^[[Z' 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
export REMOVELEADINGSPACES='{if(NR==1 && $1~/^ *[[:digit:]]+[*]? */){$1=""};gsub(/\\n/,RS);print}'

export BAT_THEME=TwoDark
export FZF_DEFAULT_OPTS="--bind='esc:print-query,tab:toggle-preview,f1:execute(less -f {}),ctrl-y:yank+abort' --preview='printf -- %s {} | awk "${(q)REMOVELEADINGSPACES}" | bat --decorations=always --pager=never --line-range :300 --number --terminal-width=\$(( FZF_PREVIEW_COLUMNS - 20 )) --color=always --language zsh /dev/stdin' --preview-window=right:40%:hidden:wrap"

# some benmakrs on bat vs https://github.com/sharkdp/bat/blob/master/doc/alternatives.md
#  *auto*, full, plain, changes, header, grid, numbers, snip.
export BAT_STYLE=snip

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
# _fzf_comprun() {
#   local command=$1
#   shift
# 
#   case "$command" in
#     cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
#     export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
#     ssh)          fzf "$@" --preview 'dig {}' ;;
#     *)            fzf "$@" ;;
#   esac
# }
# #  -history-widget() {
#   local selected num
#   setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
#   local ret=$?
#   if [ -n "$selected" ]; then
#     num=$selected[1]
#     if [ -n "$num" ]; then
#       zle vi-fetch-history -n $num
#     fi
#   fi
#   zle reset-prompt
#   return $ret
# }
