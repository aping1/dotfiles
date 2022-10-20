#!/usr/bin/env zsh
# === Shell ===
() {
    #:${PROFILING:=0}
    #
    #typeset -g DEBUG=0
    #typeset -g ZPLG_MOD_DEBUG=0
    typeset -g POWERLEVEL9K_CONFIG_FILE=${DOTFILES:-"${HOME}/.dotfiles"}/.p10k.zsh
    typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet;
}

export CLICOLOR=1
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export MYPROMPT="${MYPROMPT:-p10k}"

[[ ${+MACHINE_RC_LOADED} -eq 1 ]] \
    || { [[ -f "${HOME}/.machinerc" ]] && source "${HOME}/.machinerc"; }

# === Profiling ===
if [[ ${+PROFILING} -eq 1 ]]; then
    zmodload zsh/zprof
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
fi

# === zprofile if not autoloaded ===
[[ ${+ZPROFILE_LOADED} -eq 1 ]] \
    || source "${HOME}/.zprofile"

[[ ${+ZSH_ALIASES_LOADED} -eq 1 ]] \
    || source "${HOME}/.zsh_aliases"

# dumb terminal can be a vim dump terminal in that case don't try to load plugins

# Zinit
#    https://github.com/zdharma/zinit
#
# Functions to make configuration less verbose
function zadd() {
    #setopt # echo "ZT Installing ${1/#[0-9][a-c]/wait"$1"} ${@:2}" >&2
    zinit depth'3' lucid${1/#[0-9][a-c]/wait"$1"} "${@:2}"
}
function znotify() {
    # echo "ZT Installing ${1/#[0-9][a-c]/wait"$1"} ${@:2}" >&2
    zinit depth'3' notify ${1/#[0-9][a-c]/wait"$1"} "${@:2}"
}
function zsnippet() {
    (( $+DEBUG )) && echo " Installing snippet ${1/#[0-9][a-c]/wait"$1"} ${@:2}" >&2
    zinit snippet "${@}"
}

function zinit_prompt_theme() {
    # First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
    (( $+DEBUG )) && echo "Prompt theme ${1/#[0-9][a-c]/wait"$1"} ${@:2}" >&2
    thmf="${DOTFILES:-${HOME}/.dotfiles}/config/zsh/themes"
    # NOTE: This setups hooks to load and unload on theme changs
    [[ ${1} != ${MYPROMPT:-p10k} ]] && { ___turbo=1
    .zinit-ice load'[[ ${MYPROMPT} = '"${1}"' ]]' unload'[[ ${MYPROMPT} != '"${1}"' ]]'
    }

    # This creates a hook to call `${MYPROMPT}-post.zsh` during the load for individual preferences by
    .zinit-ice atload'[[ -s "${thmf}/${MYPROMPT}-post.zsh" ]] && source "${thmf}/${MYPROMPT}-post.zsh" || echo failed >&2' \
        nocd id-as"${1}-theme";

    (( $+ZINIT_ICE && $+DEBUG )) && echo "ICES ${(kv)ZINIT_ICES[@]}" >&2
    ICE+=("${(kv)ZINIT_ICES[@]}"); ZINIT_ICES=();
}

function __p10k_quickprompt()
{
    # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
    # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
    # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
    # really need it.
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
    # when accepting a command line. Supported values:
    #
    #   - off:      Don't change prompt when accepting a command line.
    #   - always:   Trim down prompt when accepting a command line.
    #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
    #               typed after changing current working directory.
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
    # If p10k is already loaded, reload configuration.
    # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
    # Tell `p10k configure` which file it should overwrite.
    typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
    [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
}

function __required_sbin()  {
    zadd 0a light-mode binary from"gh-r" for \
        as"program" \
        junegunn/fzf-bin

    # MilesCranmer/vim-stream
    zadd 0c light-mode binary for \
        as"null" sbin"vims" MilesCranmer/vim-stream \
        sbin"bin/git-ignore" atload'export GI_TEMPLATE="$PWD/.git-ignore"; alias gi="git-ignore"' \
        laggardkernel/git-ignore \
        binary from"gh-r" as"program" \
        jesseduffield/lazygit \
        jesseduffield/lazydocker \
        compile'{*.zsh,tmux/*.zsh,task/*.zsh,project/*}' \
        multisrc'{init.zsh,*/init.zsh}' from'null' \
        _local/fbtools
}

if [ ! $TERM = dumb ]; then
    () {
    emulate -L zsh
    setopt promptsubst

    (( $+DEBUG )) && {  trap 'unsetopt xtrace' EXIT; setopt xtrace; }

    ZINIT_DOTFILES="${HOME}/.zsh/zinit"
    ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-"${HOME}/.zsh/zinit"}}}"
    ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-$ZPLG_BIN_DIR_NAME}:-bin}"

    # Auto install zinit
    if [ ! -f ${ZINIT_DOTFILES}/${ZINIT_BIN_DIR_NAME}/zinit.zsh ] && ((${+commands[git]})); then
        __zinit_just_installed=1
        [[ -d ${ZINIT_DOTFILES}/${ZINIT_BIN_DIR_NAME} ]] && rmdir ${ZINIT_DOTFILES}/${ZINIT_BIN_DIR_NAME}
        mkdir -p ${ZINIT_DOTFILES} || return 1
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
        command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_DOTFILES}/${ZINIT_BIN_DIR_NAME}" && \
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    fi

    ##################
    # Zinit Setup    #
    #                #
    #                #
    ##################
    typeset -gA ZINIT
    (( $+DEBUG )) && ZINIT[DTRACE]=0
    ZINIT[HOME_DIR]="${ZINIT_DOTFILES}"
    unset ZINIT_DOTFILES # Use ZINIT[HOME_DIR] from now on
    # Source zinit
    source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh"

    if [ -z "$skip_global_compinit" ]; then
        autoload -Uz _zinit
        (( ${+_comps} )) && _comps[zinit]=_zinit
    fi

    [ -n "$__zinit_just_installed" ] && \
        zinit self-update

    [[ "${ZINIT[PLUGINS_DIR]}"  && -d "${ZINIT[PLUGINS_DIR]}" ]] || return 254

    autoload -Uz is-at-least

    if is-at-least 5.2 ; then
        typeset -g MY_ZINIT_USE_TURBO=true
    fi

    ##################
    # Initial Prompt #
    #    Annexes     #
    # Config source  #
    ##################
    zadd wait'!' light-mode compile'*handler' for \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-submods \
        zdharma-continuum/zinit-annex-man

    # create main local config from "${ZINIT[PLUGINS_DIR]}/_local---config-files"
    [[ -d "${DOTFILES}/config/zsh" ]] && (
        cd "${ZINIT[PLUGINS_DIR]}"
        [[ ! -h _local---config-files ]] && rm _local---confif-files >&2
        [[ ! -e _local---config-files ]] && ln -s "${DOTFILES}/config/zsh" _local---config-files;
    )

    # Creates local plugins
    for plugin_path in "${DOTFILES}/plugins/"*/init.zsh; do
        [[ ${plugin_path:a:h} == "${DOTFILES}/plugins/" ]] && continue
        plugin_name="${plugin_path:a:h:t}"
        (( $+DEBUG )) && echo "Linking \"${plugin_path:a:h}\" \" -> ${ZINIT[PLUGINS_DIR]}/_local---${plugin_name}\"" >&2
        if [[ "${plugin_name}" && ! -e "${ZINIT[PLUGINS_DIR]}/_local---${plugin_name}" && -d "${plugin_path:a:h}" ]]; then
            ln -s "${plugin_path:a:h}" "${ZINIT[PLUGINS_DIR]}/_local---${plugin_name}"
        fi
    done # end for plugin_path in ...


    ######################
    # Main Theme         #
    # Config & quickstart#
    ######################
    zadd wait light-mode for \
        pick'async.zsh'\
            mafredri/zsh-async \
        pick'*vi-mode'\
        atload'bindkey -v' \
            OMZP::vi-mode \
        if'zinit_prompt_theme p10k' \
            atload'__p10k_quickprompt' \
                reset-prompt romkatv/powerlevel10k \
        from'null' pick'config-files.plugin.zsh' \
        src'bindings.zsh' \
            _local/config-files \
        from'gh' as"null" \
            Shougo/dein.vim

    ######################
    # Trigger-load block #
    ######################
    zadd load light-mode for \
        trigger-load'!x' \
        OMZ::plugins/extract/extract.plugin.zsh \
        trigger-load'!man' \
        ael-code/zsh-colored-man-pages  \
        trigger-load'!ga;!gcf;!gclean;!gd;!glo;!grh;!gss' \
        wfxr/forgit \
        trigger-load'!dotbare;!fadd;!fedit;!finit;!fstat;!flog;fcheckout' \
        kazhala/dotbare \
        trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh'  \
        atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atload\"zinit creinstall -q _local/config-files; zicompinit_fast\" for /dev/null; gencomp"' \
        RobSis/zsh-completion-generator

    function zinit_plugin_loaded_callback() {
        emulate -L zsh
        local _zinit_plug_function="zinit-loaded-${ZINIT[CUR_PLUGIN]}"
        (( $+functions[${_zinit_plug_function}] )) && \
            $_zinit_plug_function >&2 || \
            zinit-loaded-plugin-callback
        }


    ##################
    # Wait'0a' block #
    # completions
    # autosuggest
    ##################
    zadd 0a light-mode for \
        zsh-users/zsh-completions \
        compile'{hsmw-*,test/*}' \
        atload'zinit_plugin_loaded_callback' \
        zdharma-continuum/history-search-multi-word \
        as"completions" \
        bindmap'^T -> ^F; ^R -> ^T' \
        pick"shell/key-bindings.zsh" \
        id-as"junegunn/fzf_master" src"shell/completion.zsh" \
        atload'zinit_plugin_loaded_callback' \
        junegunn/fzf \
        has'zshz' \
        bindmap'^I -> ^B' \
        pick'fz.sh' atinit'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(__fz_zsh_completion)'\
        atload'zinit_plugin_loaded_callback' \
        changyuheng/fz \
        has'fzf' \
        bindmap'^R -> ^K' \
        compile'{fzf-tab.zsh,lib/*/init.zsh' \
        pick'fzf-tab.plugin.zsh' \
        atload'zinit_plugin_loaded_callback' \
        Aloxaf/fzf-tab \
        from'gh' git \
        has'go' \
        OMZP::golang \
        has'brew' \
        OMZP::brew \
        has'systemctl' \
        atinit'export SYSTEMD_EDITOR=${EDITOR:-vim}' \
        OMZ::plugins/systemd/systemd.plugin.zsh \
        from'gh' atload'bindkey "\eP" fuzzy-search-and-edit' \
        seletskiy/zsh-fuzzy-search-and-edit


    ##################
    # Wait'0b' block #
    ##################
    # if'command -v gdircolors || command -v dircolors' pack'no-dir-color-swap' patch"$pchf/%PLUGIN%.patch" reset \
    # trapd00r/LS_COLORS \
    zadd 0b light-mode for \
        bric3/nice-exit-code \
        hcgraf/zsh-sudo \
        has'go' \
        OMZP::golang \
        has'brew' \
        OMZP::brew \
        has'systemctl' \
        OMZP::systemd/systemd.plugin.zsh \
        bpick'*linux*' atinit'alias open='\''xdg-open'\' \
        zdharma-continuum/null \
        bpick'*darwin*' atinit'unalias open' \
        zdharma-continuum/null \
        bpick'*darwin*' \
        load'[[ $TERM_PROGRAM == iTerm.app ]]' \
                OMZP::iterm2 \
                OMZP::xcode  \
        pick'autopair.zsh' \
        atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
            hlissner/zsh-autopair \
        atload'zstyle '\'':completion:*:*:git:*'\'' script $PWD/git-completion.bash' \
            felipec/git-completion \
        mv'contrib/completion/git-completion.zsh -> _git' \
            git/git \
        as"program" pick"bin/git-dsf" \
            zdharma-continuum/zsh-diff-so-fancy \
        atclone"gencomp k; ZINIT[COMPINIT_OPTS]='-i' zpcompinit" atpull'%atclone' \
        atinit'(( $+aliases[ls] )) && unalias ls; (( $+functions[ls])) && unset -f ls; alias ls=k' \
            supercrabtree/k \
        from'gh' pick'zsh-z.plugin.zsh' \
        agkozak/zsh-z \
        multisrc'helpers.d/*.zsh' from'null' \
            _local/helpers

        zadd wait light-mode for \
            atload'__required_sbin' compile'*handler'\
            zdharma-continuum/zinit-annex-bin-gem-node

        # Async Highligting & Compinit
        zadd 0c light-mode for \
            atinit'ZINIT[COMPINIT_OPTS]=-C;(( $+funtions[zicompinit_fast] )) && \
            zicompinit_fast || ZINIT[COMPINIT_OPTS]='-i' zpcompinit; zicdreplay' \
            atload'FAST_HIGHLIGHT[use_async]=1' \
            zdharma-continuum/fast-syntax-highlighting \
            compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
            atload'_zsh_autosuggest_start && zinit_plugin_loaded_callback' \
            zsh-users/zsh-autosuggestions \
            atload'zinit_plugin_loaded_callback' \
            as"program" from"gh-r" \
            sei40kr/zsh-fast-alias-tips \
            sei40kr/fast-alias-tips-bin \
            as"null" id-as'Cleanup0c' nocd nocompile \
            atload'unset -f __required_sbin;' \
                zdharma-continuum/null

        # removed git.zsh from below
        zinit ice wait"!" svn multisrc'{completion.zsh,history.zsh,functions.zsh}' notify
        zsnippet OMZ::lib
        zinit ice as'completion';
        zinit snippet OMZ::plugins/pip/_pip
        zinit ice wait"0b" lucid
        zsnippet OMZ::plugins/web-search
        zsnippet OMZ::plugins/pip
        zsnippet OMZ::plugins/git
        zsnippet OMZ::plugins/python
        zsnippet OMZ::plugins/jsontools
        zinit ice wait"0b" lucid as'completion' has'terraform'
        zsnippet OMZ::plugins/terraform
        zinit ice wait"0b" lucid as'completion' has'helm'
        zsnippet OMZ::plugins/helm
        zinit ice wait"0b" lucid as'completion' has 'docker'
        zsnippet OMZ::plugins/docker-compose
        zsnippet OMZ::plugins/docker-machine
}
####################################
fi

# Tear Down profiling
if (( $+PROFILING )); then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof
fi

export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
