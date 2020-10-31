# use ${0:h} to get plugin's directory
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# add our plugin's custom functions to the fpath
fpath=("${0:h}/functions" "${fpath[@]}")
autoload -Uz $fpath[1]/*(.:t)
#
#########################
#       Variables       #
#########################
# IF EXECTUABLE Bat
typeset -g BAT_THEME=TwoDark
# some benmakrs on bat vs https://github.com/sharkdp/bat/blob/master/doc/alternatives.md
#  *auto*, full, plain, changes, header, grid, numbers, snip.
typeset -g BAT_STYLE=snip

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
# export OPENCV_LOG_LEVEL=ERROR # Hide nonimportant errors for howdy
# export rm_opts=(-I -v)

# Git
typeset -g GIT_DISCOVERY_ACROSS_FILESYSTEM=true # etckeeper on bedrock

AUTO_LS_NEWLINE=false

# forgit
forgit_ignore="/dev/null" #replaced gi with local git-ignore plugin

# Export variables when connected via SSH
if [[ -n $SSH_CONNECTION ]]; then
    export DISPLAY=:0
fi

# 'cd -' completes with recent dirs from temp files. (this is a smaller list that z and uses menu complete)
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

# -- Opts --------------
# [ZSH: Options](http://zsh.sourceforge.net/Doc/Release/Options.html)

# -- History --------------
setopt EXTENDED_HISTORY HIST_BEEP
# Allow multiple terminal sessions to all append to one zsh command history
setopt append_history
# inc_append_history writes AFTER command completes to prserve exec time
setopt INC_APPEND_HISTORY_TIME 

# delete old recorded entry if new entry is a duplicate.
setopt hist_ignore_all_dups 
setopt HIST_EXPIRE_DUPS_FIRST

setopt log # logs all function defs too aka NO_hist_no_functions store functions in history

# MAX Entries in a history files
typeset -g HISTSIZE="50000";
# MAX Entries returned from HISTORY queries
[[ ${HISTSIZE:-''} != '' && ${HISTSIZE} -gt 0 ]] && typeset -g HISTFILESIZE=$(( HISTSIZE * 1024 )) || unset HISTFILESIZE

typeset -g HISTORY_FILTER_EXCLUDE=("_KEY", "Authorization: ", "_TOKEN")

# NOTE: Enabling this sets your completion function
# typeset -g COMPLETION_WAITING_DOTS="true"

# don't push multiple copies of the same directory onto the directory stack
setopt pushd_ignore_dups

# === Customization ===
# -- PROMPT --- 
setopt notify               # Report Status immediatly when fg changes
setopt no_beep              # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# (NO_ = Don't) allow short forms for loops
setopt SHORT_LOOPS

# Syntactic Surgar
# perform implicit tees or cats when multiple redirections are attempted
setopt multios

# -- Read more at: https://www.commandlinux.com/man-page/man1/zshoptions.1.html
# -- (NO_ Dont) Print a carriage return just before printing a prompt in the line editor.  This is on by default as so the editor knows where the start of the line appears.
#setopt no_prompt_cr
# -- (NO_=dont) Interpret  any  integer constant beginning with a 0 as octal
# -- (NO_=dont) output hexadecimal numbers in the standard C format, for example `0xFF' instead of the usual `16#FF' & 077 vs. `8#77`
#setopt octal_zeroes c_bases
# -- ignore Ctrl-d unless pressed twice
#setopt IGNORE_EOF

# --- Completions --------------
set_glob_opts() {
    setopt globcomplete globsubst numericglobsort nomatch
}

set_noglob_opts() {
    setopt noglobcomplete noglobsubst nonumericglobsort
    # provide an error when glob does not match
    setopt nonomatch 
}

# -- Auto complete from anywhere in word
# setopt COMPLETE_IN_WORD 
#
# -- (NO_ dont) use menu complete automatically if trigger complete twice
#setopt no_auto_menu
#
# -- (NO_ dont) jump to end on accept
setopt no_always_to_end 

setopt promptsubst          # enable parameter expansion, command substitution, and arithmetic expansion in the prompt

setopt extendedglob 

setopt AUTO_PARAM_SLASH # adds a slash to parameters that are directories
setopt RM_STAR_WAIT # ignore input for 10 seconds when rm uses a * based glob to prevent reflexive deleteing
setopt no_glob_dots   # (NO_ do require) dont require leading . in filname matches
setopt braceccl # Expand char clasess like zsh's [...] file expn. {abc0-9} -> a b c 0 1 2 etc...
# --  Try  to  make  the  completion  occupying less lines by printing the matches in columns with different widths.
#setopt list_packed
# -- sequence  `'''  to signify a single quote in singly quoted strings
# -- Note: Does not work in $'...' instead use \'
#setopt rc_quotes 

# -- CD  Optionn --------- 
setopt NO_CDABLE_VARS # -- (NO dont) assume when passing params to cd builtin that is not a directory to be the name of a variable whose value is a directory
setopt auto_cd # if $0 && ! command -v $0 dir in your cdpath, go there
setopt auto_pushd           # make cd push the old directory onto the directory stack
setopt pushdminus           # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean

# -- Treat arrays in globs as item expands {a,b} == ${(@):-(a b)} 
# -- Note: that an empty array will therefore cause all arguments to be removed
setopt RC_EXPAND_PARAM

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

# LISTMAX -- automatically decide when to page a list of completions
# LISTMAX=0

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
