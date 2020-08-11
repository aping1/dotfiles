#!/usr/bin/env zsh
#b
# === Shell ===
export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
export MYPROMPT="${MYPROMPT:-p10k}"


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

export ZINIT_DOTFILES="${HOME}/.zsh/zinit/"
# dumb terminal can be a vim dump terminal in that case don't try to load plugins
if [ ! $TERM = dumb ]; then
    setopt promptsubst
    {
        # Compile zcompdump only if modified, to increase startup speed.
        zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
        if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
            zcompile "$zcompdump"
        fi
    } &!

    if [ ! -f ${ZINIT_DOTFILES}/bin/zinit.zsh ] && ((${+commands[git]})); then
        __zinit_just_installed=1
        [[ -d ${ZINIT_DOTFILES}/bin ]] && rmdir ${ZINIT_DOTFILES}/bin 
        mkdir -p ${ZINIT_DOTFILES} &&  \
            chmod g-rwX "${ZINIT_DOTFILES}" && git clone --depth=1 https://github.com/zdharma/zinit.git $ZINIT_DOTFILES/bin
    fi

    # load zgen
    source "${DOTFILESDEPS:-"${HOME}"}/zgen/zgen.zsh"
    if [ -f ${ZINIT_DOTFILES}/bin/zinit.zsh ]; then
        declare -A ZINIT

        ZINIT[HOME_DIR]="${ZINIT_DOTFILES}"

        source "${ZINIT_DOTFILES}/bin/zinit.zsh"

        if [ -z "$skip_global_compinit" ]; then
            autoload -Uz _zinit
            (( ${+_comps} )) && _comps[zinit]=_zinit
        fi

        [ -n "$__zinit_just_installed" ] && \
            zinit self-update

        unset ZINIT_DOTFILES # Use ZINIT[HOME_DIR] from now on

        [ ${${(s:.:)ZSH_VERSION}[1]} -ge 5 ] && [ ${${(s:.:)ZSH_VERSION}[2]} -gt 2 ] && \
            MY_ZINIT_USE_TURBO=true
    fi

###########
# Plugins #
###########
_zsh_dotfiles_plugins=(
    ${DOTFILES}/plugins/fbtools
    ${DOTFILES}/plugins/helpers
    ${DOTFILES}/plugins/navigation
    ${DOTFILES}/plugins/autocomplete-extra
    ${DOTFILES}/plugins/images
)

_zsh_dotfiles_themes=(
    ${DOTFILES}/themes
)


    function __zinit_plugin_loaded_callback() {
        # Transistion between vi states faster (default: 4)
        # KEYTIMEOUT=1

        if [[ "$ZINIT[CUR_PLUGIN]" == "zsh-autosuggestions" ]]; then
            ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]/forward-char}")
            ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=forward-char
            export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
            (( $+ZSH_HIGHLIGHT_STYLES )) && \
                export ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow'

            export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
            # ZSH_AUTOSUGGEST_STRATEGY=(history completion)
            # Red
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1,underline"
            export ZSH_AUTOSUGGEST_USE_ASYNC="y"
        elif [[ "$ZINIT[CUR_PLUGIN]" == "zsh-history-substring-search" ]]; then
            bindkey "\ek" history-substring-search-up
            bindkey "\ej" history-substring-search-down
        fi
    }

    ### Added by Zinit's installer
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
        command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    fi



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-$HOME}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-$ZPLG_BIN_DIR_NAME}:-bin}"
### Added by Zinit's installer
if [[ ! -f $ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
wait % &>/dev/null
source "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

#module_path+=( "${HOME}/.zinit/bin/zmodules/Src" )
#zmodload zdharma/zplugin &>/dev/null

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
# zct(): First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
function zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }
function zct() {
    thmf="${DOTFILES:-${HOME}/.dotfiles}}/config/zsh/themes"
    [[ ${1} != ${MYPROMPT=p10k} ]] && { ___turbo=1; .zinit-ice \
        load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" }
            .zinit-ice atload'! [[ -f "${thmf}/${MYPROMPT}-post.zsh" ]] && source "${thmf}/${MYPROMPT}-post.zsh"' \
                nocd id-as"${1}-theme";
                            ICE+=("${(kv)ZINIT_ICES[@]}"); ZINIT_ICES=();
                        }

##################
# Initial Prompt #
#    Annexes     #
# Config source  #
##################

zt light-mode for \
    pick'async.zsh' \
    mafredri/zsh-async \
    if'zct p10k' \
        light-mode pick"async.zsh" \
        romkatv/powerlevel10k  \

    zt light-mode compile'*handler' for \
        zinit-zsh/z-a-patch-dl \
        zinit-zsh/z-a-bin-gem-node \
        zinit-zsh/z-a-submods

    # Taken from [here](https://github.com/zdharma/zinit-configs/tree/28bc8ff51f632c603f5ad80d83f4273acdc12606/NICHOLAS85/.zinit/plugins/_local---config-files)
    # requires
    #if [[ ! -d "${ZINIT[PLUGINS_DIR]}/_local---config-files" ]]; then
    #    print -P "%F{33}▓▒░ %F{220}Installing local config-files…%f"
    #    curl https://codeload.github.com/aping1/dotfiles/tar.gz/$(MACHINEID:-aping1mba}| \
    #        tar -xz --strip=3 dotfiles-xps_13_9365/.zinit/plugins/_local---config-files
    #            mv _local---config-files "${ZINIT[PLUGINS_DIR]}/"
    #fi

    if [[ ! -d "${ZINIT[PLUGINS_DIR]}/_local---config-files" && -d "${DOTFILES}/config/zsh" ]]; then
        ln -s "${DOTFILES}/config/zsh" "${ZINIT[PLUGINS_DIR]}/_local---config-files"
    fi
    # Loads "${DOTFILES}/config/zsh/config-files.plugin.zsh" 
    zt light-mode blockf for \
        _local/config-files

    ###########
    # Plugins #
    ###########
    # Set the default source to github
    zinit wait'!' lucid for \
        light-mode \
        OMZP::vi-mode \
        OMZP::docker-compose \
        OMZP::brew \
        OMZP::terraform \
        OMZP::urltools \
        OMZP::web-search \
        OMZP::npm \
        OMZP::iterm2 \
        OMZP::emoji \
        OMZP::helm \
        OMZP::pip \
        OMZP::python 
# zgen will load oh-my-zsh and download it if required
zt  for \
    OMZL::history.zsh

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' \
    OMZ::plugins/extract/extract.plugin.zsh \
    trigger-load'!man' \
    ael-code/zsh-colored-man-pages
    # trigger-load'!ga;!gcf;!gclean;!gd;!glo;!grh;!gss' \
    # wfxr/forgit
    # trigger-load'!zshz' blockf \
    # agkozak/zsh-z \
    # trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' blockf \
    # atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atload\"zinit creinstall -q _local/config-files; zicompinit\" for /dev/null; gencomp"' \
    # RobSis/zsh-completion-generator

##################
# Wait'0a' block #
##################

    ### End of Zinit's installer chunk
    zinit wait lucid depth=1  \
        atload='__zinit_plugin_loaded_callback' \
        pick='init.zsh' \
        for "${_zsh_dotfiles_plugins[@]}"

zt 0a light-mode for \
    OMZL::completion.zsh \
    if'false' ver'dev' \
        marlonrichert/zsh-autocomplete \
        has'systemctl' \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
        blockf \
        zsh-users/zsh-completions \
        compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
        atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions 
        # pick'fz.sh' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert __fz_zsh_completion)' \
        #     changyuheng/fz

##################
# Wait'0b' block #
##################

zt 0b light-mode for \
    pack'no-dir-color-swap' patch"$pchf/%PLUGIN%.patch" reset \
    trapd00r/LS_COLORS \
    trackbinds bindmap'\e[1\;6D -> ^[[1\;5B; \e[1\;6C -> ^[[1\;5A' patch"$pchf/%PLUGIN%.patch" \
    reset pick'dircycle.zsh' \
    michaelxmcbride/zsh-dircycle \
    autoload'#manydots-magic' \
    knu/zsh-manydots-magic \
    atinit'zicompinit_fast; zicdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
    zdharma/fast-syntax-highlighting \
    as'completion' mv'*.zsh -> _git' \
    felipec/git-completion

##################
# Wait'0c' block #
##################

zt 0c light-mode for \
    pack'bgn-binary' \
    junegunn/fzf \
    sbin from'gh-r' pick'plugin/*.zsh' \
    sei40kr/fast-alias-tips-bin

zt 0c light-mode binary for \
    sbin'fd*/fd;fd*/fd -> fdfind' from"gh-r" \
    @sharkdp/fd \
    sbin'bin/git-ignore' atload'export GI_TEMPLATE="$PWD/.git-ignore"; alias gi="git-ignore"' \
    laggardkernel/git-ignore

zt 0c light-mode null for \
    sbin"bin/git-dsf;bin/diff-so-fancy" \
    zdharma/zsh-diff-so-fancy \
    sbin \
    paulirish/git-open \
    sbin'm*/micro' from"gh-r" ver'nightly' bpick'*linux64*' reset \
    zyedidia/micro \
    sbin \
    kazhala/dotbare \
    id-as'Cleanup' nocd atinit'unset -f zct zt; SPACESHIP_PROMPT_ADD_NEWLINE=true; _zsh_autosuggest_bind_widgets' \
    zdharma/null


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
