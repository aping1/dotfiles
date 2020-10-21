#Let Atom highlight this: -*- shell-script -*-

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h}/functions to get plugin's directory
# add our plugin's custom functions to the fpath
fpath=("${0:h}/functions" "${fpath[@]}")
autoload -Uz $fpath[1]/*(.:t)

#! $isdolphin && add-zsh-hook chpwd chpwd_ls
# run `clear -x` on `cd` while in Dolphin
# $isdolphin && alias cd='clear -x; cd'
#
#########################
#       Variables       #
#########################
ZSHZ_DATA="${ZPFX}/z"
pchf="${0:a:h}/patches"
thmf="${0:a:h}/themes"
GENCOMPL_FPATH="${0:a:h}/completions"
# This colorizes alias that are available for your command
FAST_ALIAS_TIPS_PREFIX="» $(tput setaf 6)"
FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0) «"

ZSHZ_DEBUG=0
# In FreeBSD, /home is /usr/home
[[ $OSTYPE == freebsd* ]] && typeset -g ZSHZ_NO_RESOLVE_SYMLINKS=1

# export CUSTOMIZEPKG_CONFIG="${HOME}/.config/customizepkg"
#export OPENCV_LOG_LEVEL=ERROR # Hide nonimportant errors for howdy
#export rm_opts=(-I -v)
#
# automatically decide when to page a list of completions
# LISTMAX=0

# Git
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true # etckeeper on bedrock

# Autols
(( $+command[lsd] )) \
    && typeset -g AUTO_LS_COMMANDS="lsd" \
    || typeset -g AUTO_LS_COMMANDS='ls'

AUTO_LS_NEWLINE=false

# forgit
forgit_ignore="/dev/null" #replaced gi with local git-ignore plugin

#### DOTSCHECK
# Strings to ignore when using dotscheck, escape stuff that could be wild cards (../)
# dotsvar=( gtkrc-2.0 kwinrulesrc '\.\./' \.config/gtk-3\.0/settings\.ini )

# Export variables when connected via SSH
if [[ -n $SSH_CONNECTION ]]; then
    export DISPLAY=:0
fi

# if [[ $MYPROMPT = dolphin ]]; then
#     isdolphin=true
# else
if [[ $MYPROMPT != dolphin ]]; then
     isdolphin=false
     autoload -Uz chpwd_recent_dirs add-zsh-hook
     add-zsh-hook chpwd chpwd_recent_dirs
     zstyle ':chpwd:*' recent-dirs-file "$TMPDIR/chpwd-recent-dirs"
     (){
         local chpwdrdf
         zstyle -g chpwdrdf ':chpwd:*' recent-dirs-file
         dirstack=($(awk -F"'" '{print $2}' "$chpwdrdf" 2>/dev/null))
         [[ $PWD = ~ ]] && { cd ${dirstack[1]} 2>/dev/null || true }
         dirstack=("${dirstack[@]:1}")
     }
fi

# Bedrock integration
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

# -- History --------------
# change the size of history files
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE
export HISTORY_FILTER_EXCLUDE=("_KEY" "Authorization: ", "_TOKEN")

setopt EXTENDED_HISTORY HIST_BEEP
setopt append_history       # Allow multiple terminal sessions to all append to one zsh command history
setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY_TIME # inc_append_history writes AFTER command completes to prserve exec time
setopt hist_ignore_all_dups # delete old recorded entry if new entry is a duplicate.
setopt log # logs all function defs too aka NO_hist_no_functions store functions in history

# -- Opts --------------
# [ZSH: Options](http://zsh.sourceforge.net/Doc/Release/Options.html)
# Auto complete from anywhere in word
# setopt COMPLETE_IN_WORD 
#
# cdable_vars: If this is set, an argument to the cd builtin command that is not a directory is assumed to be the name of a variable whose value is the directory to change to.
setopt NO_CDABLE_VARS

# NOTE: Enabling this sets your completion function
# typeset -g COMPLETION_WAITING_DOTS="true"

# === Customization ===
setopt braceccl AUTO_PARAM_SLASH 
setopt extendedglob nomatch 
setopt pushd_ignore_dups    # don't push multiple copies of the same directory onto the directory stack
# dont jump to end on accept
setopt no_always_to_end 

# Read more at: https://www.commandlinux.com/man-page/man1/zshoptions.1.html
#setopt octal_zeroes   no_prompt_cr
#setopt list_pac
#setopt complete_in_word  no_auto_menu
#setopt no_glob_complete  no_glob_dots   c_bases
#setopt numeric_glob_sort no_share_history
#setopt rc_quotes notify

#setopt IGNORE_EOF
#setopt NO_SHORT_LOOPS
#setopt PRINT_EXIT_VALUE
#setopt RM_STAR_WAIT
setopt no_beep              # don't beep on error
setopt auto_cd              # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
setopt promptsubst         # enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)
setopt auto_pushd           # make cd push the old directory onto the directory stack
setopt pushdminus           # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean

set_glob_opts() {
    setopt globcomplete globsubst numericglobsort
}

set_noglob_opts() {
    setopt noglobcomplete noglobsubst nonumericglobsort
}
#
#########################
# [man] zshcompsys
#    zstyle [ - | -- | -e ] pattern style string ...
#                Defines the given style for the pattern with the strings as the value.
#                In this case the parameter `reply' must be assigned to set the strings
#                returned after the evaluation.  Before evaluating the value, reply is unset, and if it is still unset after the evaluation,
#                the style is treated as if it were not set.
##########################
zmodload zsh/complist

# Enable approximate completions
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true # Automatically update PATH entries
zstyle ':completion:*' single-ignored show
zstyle ':completion:*' verbose yes

# If the -e option is given, the strings will be con-catenated (separated by spaces) and 
#     the resulting string will be evaluated (in the same way as  it  is  done  
#     by  the  eval builtin  command)  when  the  style  is  looked up. 
#
# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' group-name ''
# zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>${MAX_ERROR:-7}?${MAX_ERROR:-7}:($#PREFIX+$#SUFFIX)/3)) numeric)'

zstyle ':completion:*' format '%S%F{green} -- %d -- %s%f'

# Nicer format for completion messages
zstyle ':completion:*:default' list-prompt '%S%F{green}%M matches%s%f'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:descriptions' format '%U%B%F{magenta}~ %d ~%b%u%f%u'
zstyle ':completion:*:corrections' format '%F{green}%U%d %F(red)(errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{yellow}%BSorry, no matches for: %F{3}%d%b%f'

# what is this??
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:matches' group 'yes'

# Pretty messages during pagination (menu==[long-]list)
zstyle ':completion:*:default' list-prompt '%S%F{green}%M matches%s%f'
zstyle ':completion:*' list-prompt '%F{green}%%SAt %p:%f Hit TAB for %M more%s%f'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Don't complete hosts from /etc/hosts
zstyle -e ':completion:*' hosts 'reply=()'

zstyle ':completion:complete:*:options' sort false

# NOTE: zstyle ... menu= ...
#  'yes' or 'true' or '1' or 'no' (negate) etc
#    yes=# and/or yes=list|long-list # menu if larget than #, 
#    and/or long if larget than scrte   
#    select=# and/or select=list|long-list # menu with select optionif larget than #, 
#    and/or long if larget than scrte   
#
# Change completion menu select Scroll distance
# zstyle ':completion:*:default'  select-scroll=$(($(tput lines) / 2 + 1))

# Ignore these functions when autocompleting
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Reference: https://github.com/ThiefMaster/zsh-config/blob/master/zshrc.d/completion.zsh
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes=interactive yes=16 select=long-list

zstyle ':completion:*:*:git:*:option' menu select=interactive yes=interactive
zstyle ':completion:*:*:ag:*:*' menu select=interactive yes=interactive

# Better SSH/Rsync/SCP Autocomplete
# from https://www.codyhiar.com/blog/zsh-autocomplete-with-ssh-config-file/
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
# from https://www.codyhiar.com/blog/zsh-autocomplete-with-ssh-config-file/
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

#
zstyle ':completion:*:*:*:*:file' menu select=interactive yes=long-list
# Prettier completion for processes


zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu select=interactive yes=long-list
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"

zstyle ':completion:*:complete:ls:*:*' verbose yes

# Don't complete uninteresting stuff unless we really want to.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|TRAP*)'


# IF EXECTUABLE Bat
export BAT_THEME=TwoDark
# some benmakrs on bat vs https://github.com/sharkdp/bat/blob/master/doc/alternatives.md
#  *auto*, full, plain, changes, header, grid, numbers, snip.
export BAT_STYLE=snip

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

# 


# Code to set a timed callback for autocomplete (depricated)
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
#export FZ_HISTORY_LIST_GENERATOR=___fz_generate_matched_subdir_list
# function ___fz_generate_matched_subdir_list () {
#     __fz_generate_matched_subdir_list ${PWD}
# }
