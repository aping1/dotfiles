#Let Atom highlight this: -*- shell-script -*-

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin's directory

# Autoload personal functions
fpath=("${0:h}/functions" "${fpath[@]}")
autoload -Uz $fpath[1]/*(.:t)

#! $isdolphin && add-zsh-hook chpwd chpwd_ls

#########################
#       Variables       #
#########################

pchf="${0:h}/patches"
thmf="${0:h}/themes"
GENCOMPL_FPATH="${0:h}/completions"
# WD_CONFIG="${ZPFX}/warprc"
# ZSHZ_DATA="${ZPFX}/z"
# AUTOENV_AUTH_FILE="${ZPFX}/autoenv_auth"
# export CUSTOMIZEPKG_CONFIG="${HOME}/.config/customizepkg"

# Directory checked for locally built projects (plugin NICHOLAS85/updatelocal)
# UPDATELOCAL_GITDIR="${HOME}/github/built"

export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c100,)"
ZSH_AUTOSUGGEST_MANUAL_REBIND=set
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
FAST_ALIAS_TIPS_PREFIX="» $(tput setaf 6)"
FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0) «"
HISTORY_SUBSTRING_SEARCH_FUZZY=set

# Auto complete from anywhere in word
setopt COMPLETE_IN_WORD BRACE_CCL AUTO_PARAM_SLASH GLOBCOMPLETE
setopt globcomplete globsubst
export COMPLETION_WAITING_DOTS="true"

# automatically decide when to page a list of completions
# LISTMAX=0

# -- History --------------
# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST


setopt EXTENDED_HISTORY HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
# setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

# === Customization ===
setopt extendedglob nomatch

fi


#export OPENCV_LOG_LEVEL=ERROR # Hide nonimportant errors for howdy
#export rm_opts=(-I -v)
#export EDITOR=micro
export SYSTEMD_EDITOR=${EDITOR}
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true # etckeeper on bedrock
FZF_DEFAULT_OPTS="
--border
--height 80%
--extended
--ansi
--reverse
--cycle
--bind ctrl-s:toggle-sort
--bind 'alt-e:execute($EDITOR {} >/dev/tty </dev/tty)'
--preview \"(bat --color=always {} || ls -l --color=always {}) 2>/dev/null | head -200\"
--preview-window right:60%
"
FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null"

AUTO_LS_COMMANDS="colorls"
AUTO_LS_NEWLINE=false

# FZ_HISTORY_CD_CMD=zshz
# ZSHZ_CMD="" # Don't set the alias, fz will cover that
# ZSHZ_UNCOMMON=1
forgit_ignore="/dev/null" #replaced gi with local git-ignore plugin

# Strings to ignore when using dotscheck, escape stuff that could be wild cards (../)
dotsvar=( gtkrc-2.0 kwinrulesrc '\.\./' \.config/gtk-3\.0/settings\.ini )

# Export variables when connected via SSH
if [[ -n $SSH_CONNECTION ]]; then
    export DISPLAY=:0
    alias ls="lsd --group-dirs=first --icon=never"
else
    alias ls='lsd --group-dirs=first'
fi


#########################
#       Aliases         #
#########################

# Access zsh config files
alias zshconf="(){ setopt extendedglob local_options; kate ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT}-*~*.zwc }"
alias zshconfatom="(){ setopt extendedglob local_options; atom ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT}-*~*.zwc &! }"

alias t='tail -f'
alias g='git'
# alias open='xdg-open'
# alias atom='atom-beta --disable-gpu'
# alias apm='apm-beta'
alias ..='cd .. 2>/dev/null || cd "$(dirname $PWD)"' # Allows leaving from deleted directories
# Aesthetic function for Dolphin, clear -x if cd while in Dolphin
# $isdolphin && alias cd='clear -x; cd'

# dot file management
# alias dots='DOTBARE_DIR="$HOME/.dots" DOTBARE_TREE="$HOME" DOTBARE_BACKUP="${ZPFX:-${XDG_DATA_HOME:-$HOME/.local/share}}/dotbare" dotbare'
# export DOTBARE_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"

# (( ${+commands[brl]} )) && {
# (){ local stratum strata=( /bedrock/run/enabled_strata/* )
# for stratum in ${strata:t}; do
# hash -d "${stratum}"="/bedrock/strata/${stratum}"
# alias "${stratum}"="strat ${stratum}"
# alias "r${stratum}"="strat -r ${stratum}"
# [[ -d "/bedrock/strata/${stratum}/etc/.git" ]] && \
# alias "${stratum:0:1}edots"="command sudo strat -r ${stratum} git --git-dir=/etc/.git --work-tree=/etc"
# done }
# alias bedots='command sudo DOTBARE_FZF_DEFAULT_OPTS="$DOTBARE_FZF_DEFAULT_OPTS" DOTBARE_DIR="/bedrock/.git" DOTBARE_TREE="/bedrock" DOTBARE_BACKUP="${ZPFX:-${XDG_DATA_HOME:-$HOME/.local/share}}/bdotbare" dotbare'
#}

#########################
#         Other         #
#########################

bindkey -e                  # EMACS bindings
setopt append_history       # Allow multiple terminal sessions to all append to one zsh command history
setopt hist_ignore_all_dups # delete old recorded entry if new entry is a duplicate.
setopt no_beep              # don't beep on error
setopt auto_cd              # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
setopt prompt_subst         # enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)
setopt pushd_ignore_dups    # don't push multiple copies of the same directory onto the directory stack
setopt auto_pushd           # make cd push the old directory onto the directory stack
setopt pushdminus           # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
# Enable approximate completions
# zstyle ':completion:*' completer _complete _ignored _approximate
# zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Pretty completions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:descriptions' format '%U%B%F{magenta}~ %d ~%b%u%f%u'
zstyle ':completion:*:corrections' format '%F{green}%U%d %F(red)(errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{yellow}%BSorry, no matches for: %F{3}%d%b%f'

zstyle ':completion:*' single-ignored show
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' use-cache true
# Automatically update PATH entries
zstyle ':completion:*' rehash true

zstyle ':completion:*' menu select
# Pretty messages during pagination
zstyle ':completion:*' list-prompt '%F{green}%%SAt %p: Hit TAB for %M more, or the character to insert%s%f'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Nicer format for completion messages
zstyle ':completion:*:default' list-prompt '%S%F{green}%M matches%s'
# do glob complete
zstyle ':completion:*:default' force-list
zstyle ':completion:*:default' menu select=0 
# Scroll distance
# zstyle ':completion:*:default'  select-scroll=$(($(tput lines) / 2 + 1))

# zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle -e ':completion:*:approximate:*' max-errors \
          'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 + 1 )) )'
 
#https://github.com/ThiefMaster/zsh-config/blob/master/zshrc.d/completion.zsh
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes=interactive yes=16 select=long-list

zstyle ':completion:*:*:git:*:option' menu select=interactive yes=interactive
zstyle ':completion:*:*:ag:*:*' menu select=interactive yes=interactive
zstyle ':completion:*:*:*:*:file' menu select=search
# zstyle ... menua ...
#  'yes' or 'true' or '1' or 'no' (negate) etc
#    yes=# and/or yes=list|long-list # menu if larget than #, 
#    and/or long if larget than scrte   
#    select=# and/or select=list|long-list # menu with select optionif larget than #, 
#    and/or long if larget than scrte   
zstyle ':completion:*:*:*:*:file' menu select=interactive yes=long-list
# Prettier completion for processes
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu select=interactive yes=long-list
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"

# Don't complete hosts from /etc/hosts
zstyle -e ':completion:*' hosts 'reply=()'

zstyle ':completion:*:complete:ls:*:*' verbose yes

# Don't complete uninteresting stuff unless we really want to.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|TRAP*)'

if (( $+LS_COLORS )) ; then 
    zstyle ':completion:*:default' list-colors "$~{(s.:.)LS_COLORS}"
elif (( $+ZLS_COLORS )) ; then 
    zstyle ':completion:*:default' list-colors "$~{(s.:.)ZLS_COLORS}"
fi


# Man page colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


bindkey '^[[1;5C' forward-word   # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word  # [Ctrl-LeftArrow]  - move backward one word
bindkey -s '^[[5~' ''            # Do nothing on pageup and pagedown. Better than printing '~'.
bindkey -s '^[[6~' ''
bindkey '^[[3;5~' kill-word      # ctrl+del   delete next word
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
#export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
#export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# 


#autoload -U is-at-least
#TMOUT=1
#if is-at-least 5.1; then
#    # avoid menuselect to be cleared by reset-prompt
#    redraw_tmout() {
#        if [[ "$WIDGET" =~ "^expand-or-complete$" ]]; then
#            [[ ! "$_lastcomp[insert]" =~ "^automenu$|^menu:" ]] || zle reset-prompt
#        fi
#    }
#else
#    # evaluating $WIDGET in TMOUT may crash :(
#    # redraw_tmout() { zle reset-prompt }
#fi
#TRAPALRM() { redraw_tmout }
#
export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH

export REMOVELEADINGSPACES='{if(NR==1 && $1~/^ *[[:digit:]]+[*]? */){$1=""};gsub(/\\n/,RS);print}'
export FZF_DEFAULT_OPTS="--bind='esc:print-query,tab:toggle-preview,f1:execute(less -f {}),ctrl-y:yank+abort' --preview='printf -- %s {} | awk "${(q)REMOVELEADINGSPACES}" | bat --decorations=always --pager=never --line-range :300 --number --terminal-width=\$(( FZF_PREVIEW_COLUMNS - 20 )) --color=always --language zsh /dev/stdin' --preview-window=right:40%:hidden:wrap"

export BAT_THEME=TwoDark
# some benmakrs on bat vs https://github.com/sharkdp/bat/blob/master/doc/alternatives.md
#  *auto*, full, plain, changes, header, grid, numbers, snip.
export BAT_STYLE=snip
