# 
# Enable approximate completions
# zstyle ':completion:*' completer _complete _ignored _approximate
# zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# do glob complete
zstyle ':completion:*:default' force-list
zstyle ':completion:*:default' menu select=0 
# Scroll distance
# zstyle ':completion:*:default'  select-scroll=$(($(tput lines) / 2 + 1))

# zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' rehash yes
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
zstyle ':completion:*' single-ignored show


autoload -U is-at-least
TMOUT=1
if is-at-least 5.1; then
    # avoid menuselect to be cleared by reset-prompt
    redraw_tmout() {
        if [[ "$WIDGET" =~ "^expand-or-complete$" ]]; then
            [[ ! "$_lastcomp[insert]" =~ "^automenu$|^menu:" ]] || zle reset-prompt
        fi
    }
else
    # evaluating $WIDGET in TMOUT may crash :(
    # redraw_tmout() { zle reset-prompt }
fi
TRAPALRM() { redraw_tmout }
