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
    #source "${DOTFILESDEPS:-"${HOME}"}/zgen/zgen.zsh"
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

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-"${HOME}/.zinit"}}}"
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
function za() {
    # wrapper for https://github.com/zinit-zsh/z-a-meta-plugins
    zt ${1/#[0-9][a-c]/wait"$1"}  light-mode \
        for annexes \
            "${@:2}"
}

function zct() {
    thmf="${DOTFILES:-${HOME}/.dotfiles}/config/zsh/themes"
    [[ ${1} != ${MYPROMPT:-p10k} ]] && { ___turbo=1
    .zinit-ice load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" 
    }

    .zinit-ice atload'! [[ -f "${thmf}/${MYPROMPT}-post.zsh" ]] && source "${thmf}/${MYPROMPT}-post.zsh"' \
        nocd id-as"${1}-theme";
    ICE+=("${(kv)ZINIT_ICES[@]}"); ZINIT_ICES=();
}

zt wait'!' light-mode compile'*handler' for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-meta-plugins \
    zinit-zsh/z-a-submods

za wait'!'
    zsh-users+fast

za 0c
    ext-git \
    developer
##################
# Initial Prompt #
#    Annexes     #
# Config source  #
##################

zt light-mode for \
    pick'async.zsh' \
    mafredri/zsh-async \
    if'zct p10k' \
        romkatv/powerlevel10k


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
    zt light-mode blockf pick='config-files.plugin.zsh' for \
        _local/config-files

    ###########
    # Plugins #
    ###########
    # Set the default source to github
    zinit wait'!' lucid for \
        hcgraf/zsh-sudo
        OMZP::docker-compose \
        OMZP::terraform \
        OMZP::urltools \
        OMZP::web-search \
        OMZP::npm \
        OMZP::iterm2 \
        OMZP::helm \
        OMZP::pip \
        OMZP::python 
# zgen will load oh-my-zsh and download it if required
zt  for \
    OMZL::history.zsh \
    atload='bindkey -v' \
    OMZP::vi-mode

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' \
    OMZ::plugins/extract/extract.plugin.zsh \
    trigger-load'!man' \
    ael-code/zsh-colored-man-pages 
    trigger-load'!ga;!gcf;!gclean;!gd;!glo;!grh;!gss' \
    wfxr/forgit
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

__go_history_multi()
{
    typeset -gA FAST_BLIST_PATTERNS
    FAST_BLIST_PATTERNS[/Volumes/Drobo5N2/*]=1
    zstyle ":history-search-multi-word" page-size "8"                      # Number of entries to show (default is $LINES/3)
    zstyle ":plugin:history-search-multi-word" reset-prompt-protect 1
    # zstyle ":history-search-multi-word" highlight-color "bg=yellow,fg=black,bold"   # Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
    # zstyle ":plugin:history-search-multi-word" synhl "no"                 # Whether to perform syntax highlighting (default true)
    zstyle ":plugin:history-search-multi-word" active "standout"          # Effect on active history entry. Try: standout, bold, bg=blue (default underline)
    zstyle ":plugin:history-search-multi-word" check-paths "yes"           # Whether to check paths for existence and mark with magenta (default true)
    zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"        # Whether pressing Ctrl-C or ESC should clear entered query
}

zt 0a light-mode for \
    OMZL::completion.zsh \
    if'((1))' ver'dev' \
        zinit-zsh/z-a-man \
        marlonrichert/zsh-autocomplete \
        has'brew' \
        OMZP::brew \
        has'systemctl' \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
        blockf \
        zsh-users/zsh-completions \
        compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
        atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
        atload='__go_history_multi' \
        zdharma/history-search-multi-word 
        # pick'fz.sh' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert __fz_zsh_completion)' \
        #     changyuheng/fz

##################
# Wait'0b' block #
##################
#    pack'no-dir-color-swap' patch"$pchf/%PLUGIN%.patch" reset \
#    trapd00r/LS_COLORS \

zt 0b light-mode for \
    autoload'#manydots-magic' \
    knu/zsh-manydots-magic \
    as'completion'
    OMZP::git/_git
    # as'completion' mv'*.zsh -> _git' \
    # felipec/git-completion

##################
# Wait'0c' block #
##################
zcommand from"gh-r";         zload junegunn/fzf-bin
zcommand pick"bin/fzf-tmux"; zload junegunn/fzf
# Create and bind multiple widgets using fzf
# for fzf ^R use    multisrc"shell/{completion,key-bindings}.zsh" \
zt 0c light-mode for \
    multisrc"shell/completion.zsh" \
    id-as"junegunn/fzf_completions" pick"/dev/null" \
    junegunn/fzf \
    sbin from'gh-r' pick'plugin/*.zsh' \
    sei40kr/fast-alias-tips-bin

zt 0c light-mode binary for \
    sbin'bin/git-ignore' atload'export GI_TEMPLATE="$PWD/.git-ignore"; alias gi="git-ignore"' \
    laggardkernel/git-ignore

zt 0c light-mode null for \
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


fi


# Tear Down profiling
if (( $+PROFILING )); then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof
fi

export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
