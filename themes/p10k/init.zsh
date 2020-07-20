
# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh
    setopt no_unset
    local grey0x='#abb2bf'
    local darkgrey0x=#353a44
    local red0x='#e88388'
    local green0x='#a7cc8c'
    #local yellow0x='#ebca8d' 
    local yellow0x='#DEB469'
    local blue0x='#72bef2'
    local magenta0x='#d291e4'
    local cyan0x='#65c2cd'
    local white0x='#e3e5e9'

    # Unset all configuration options.
    unset -m 'POWERLEVEL9K_*'

    # Prompt sample https://github.com/romkatv/powerlevel10k/blob/master/config/p10k-classic.zsh
    # https://github.com/romkatv/powerlevel10k/blob/master/README.md#batteries-included
    # Left prompt segments.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir                       # current directory
    vcs                       # git status
    context                   # user@host
    virtualenv                # python virtual environment
    pyenv
    terraform
    vim_shell
    newline
    time
    status
    background_jobs
    prompt_char               # prompt symbol
    )
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status
    background_jobs
    command_execution_time    # previous command duration
    time                      # current time
    newline                   # \n
    )

    autoload -Uz is-at-least 

    if is-at-least 5.7 ; then
        # NOTE: Check out the readme for notes about %F (requires 5.7.1
        # https://github.com/romkatv/powerlevel10k/blob/d0edcbc9662f20a16f16bc5c70df2c97fdc2a093/README.md#L1355 
        typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%F{'${blue0x}'}%n%F{'"${grey0x}"'}@%m%f'
        typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{'${red0x}'}%n%f %F{'"${grey0x}"'}@%m%f"
    elif ! is-at-least 5.1; then
        print '%F{'"${red0x}"'} p10k requires zsh >= 5.1%F' >&2
        return
    fi

  # ===============================================================
  # p10k 
  # ===============================================================
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  # typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

  # This has to be off for updating time in the log
  # SOURCE: https://www.reddit.com/r/zsh/comments/dsh1g3/new_powerlevel10k_feature_transient_prompt/
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off #always

  # ===============================================================
  # look and feel
  # ===============================================================
  typeset -g POWERLEVEL9K_BACKGROUND=            # transparent background
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
  if [[ ${_CENTER_SEGEMENT_FILL:-""} == true ]] ; then
    # The color of the filler.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=${darkgrey0x}
    # Add a space between the end of left prompt and the filler.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
    # Add a space between the filler and the start of right prompt.
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Magenta prompt symbol if the last command succeeded.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VICMD,VIVIS}_FOREGROUND=$cyan0x
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=$green0x
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=$cyan0x
  # Red prompt symbol if the last command failed.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VIVIS}_FOREGROUND=$red0x
  # Default prompt symbol.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  # Prompt symbol in command vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  # Prompt symbol in visual vi mode is the same as in command mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  # Prompt symbol in overwrite vi mode is the same as in command mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

  # ===============================================================
  # TIME and Completion Time
  # ===============================================================
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
  # Duration format: 1d 2h 3m 4s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$red0x
  # typeset -g POWERLEVEL9K_TIME_FOREGROUND=103 # yellow3
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$grey0x

  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'


  # ===============================================================
  # RULER
  # ===============================================================
  typeset -g POWERLEVEL9K_SHOW_RULER=true
  typeset -g POWERLEVEL9K_RULER_CHAR='─'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=${darkgrey0x}
  # ===============================================================
  # directory, path
  # ===============================================================
  #typeset -g POWERLEVEL9K_ICON_PADDING=none
  #typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false

  # Blue current directory.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$grey0x
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=4
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v2
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.bzr|.citc|.git|.hg|.node-version|.python-version|.go-version|.ruby-version|.lua-version|.java-version|.perl-version|.php-version|.tool-version|.shorten_folder_marker|.svn|.terraform|CVS|Cargo.toml|composer.json|go.mod|package.json|stack.yaml)'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=1
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
  # typeset -g POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME=0
  typeset -g POWERLEVEL9K_FVM_FOREGROUND=4

  # ===============================================================
  # IP ADDR
  # ===============================================================
  typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='$P9K_IP_IP${P9K_IP_RX_RATE:+ %2F⇣$P9K_IP_RX_RATE}${P9K_IP_TX_RATE:+ %3F⇡$P9K_IP_TX_RATE}'
  typeset -g POWERLEVEL9K_IP_FOREGROUND=4
  typeset -g POWERLEVEL9K_IP_INTERFACE='en0'

  # ===============================================================
  # LOAD 
  # ===============================================================
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=1
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=2
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=3
  typeset -g POWERLEVEL9K_LOAD_WHICH=2
  # ===============================================================
  # memory
  # ===============================================================
  typeset -g POWERLEVEL9K_SWAP_FOREGROUND=3
  # ===============================================================
  # POSIX status
  # ===============================================================
  # typeset -g POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=1
  typeset -g POWERLEVEL9K_STATUS_VERBOSE=true
  # typeset -g POWERLEVEL9K_STATUS_OK=1
  # typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_ PIPE_VISUAL_IDENTIRFIED_COLOR=${red0x}
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION=✔
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION=ﳣ
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION=!
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_COLOR=${red0x}
  typeset -g POWERLEVEL9K_STATUS_SIGNAL_FOREGROUND=${yellow0x}
  # typeset -g POWERLEVEL9K_STATUS_SIGNAL_ERROR_VISUAL_IDENTIRFIED_COLOR=${red0x}
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_HIDE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  # typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_COLOR=${green0x}


  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=1
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS=1

  # ===============================================================
  # VCS git hg mercurial
  # ===============================================================
  # Disable async loading indicator to make directories that aren't Git repositories
  # indistinguishable from large Git repositories without known state.
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=
  # Don't wait for Git status even for a millisecond, so that prompt always updates asynchronously with Git changes
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

  typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$magenta0x
  # Don't show remote branch, current tag or stashes.
  typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=
  # typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='#' #<commit>
  # Don't show staged, unstaged, untracked indicators.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_ICON=$'\b'
  # Show '*' when there are staged, unstaged or untracked files.
  typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='נּ'
  # Show '⇣' if local branch is behind remote.
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
  # Show '⇡' if local branch is ahead of remote.
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
  # Don't show the number of commits next to the ahead/behind arrows.
  typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=32
  # Remove space between '⇣' and '⇡'.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${P9K_CONTENT/⇣* ⇡/⇣⇡}'

  # ===============================================================
  # terraform (.tf)
  # ===============================================================
  # typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=( '*' DEFAULT )
  typeset -g POWERLEVEL9K_TERRAFORM_DEFAULT_FOREGROUND=4


  # ===============================================================
  # Python
  # ===============================================================
  # Grey Python Virtual Environment.
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$green0x
  # Don't show Python version.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_PYENV_PYTHON_VERSION:#$P9K_CONTENT}:+ $P9K_PYENV_PYTHON_VERSION}'
  # typeset -g POWERLEVEL9K_PYENV_FOREGROUND=37
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=${green0x}
  # Hide python version if it doesn't come from one of these sources.
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  # If set to false, hide python version if it's the same as global:
  # $(pyenv version-name) == $(pyenv global).
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  # If set to false, hide python version if it's equal to "system".
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true
  # Custom icon.
  # ===============================================================
  # timewarrior
  # ===============================================================
  typeset -g POWERLEVEL9K_TIMEWARRIOR_CONTENT_EXPANSION='${P9K_CONTENT:0:24}${${P9K_CONTENT:24}:+…}'
}

# ===============================================================
# functions
# ===============================================================
# autoload -U is-at-least
#TRAPALRM() { 
#    emulate -L zsh
#    p10k display '1|2/right'=hide '2/left/time'=show '2/left/background_jobs'=show '2/left/status'=show
# }
# TMOUT=0

# Turn timestamp on for old prompts
function p10k-on-pre-prompt() { 
    p10k display '1|2|3/right'=show '2/left/time'=hide '2/left/status'=hide '2/left/background_jobs'=hide
}
function p10k-on-post-prompt() {
    #[[ $POWERLEVEL9K_O $last_prompt_dir == $PWD ]] && \
    # hides 1st|2nd row for the right prompt segment
    # show time, background_jobs, stats on the left
    p10k display '1|2/right'=hide '2/left/time'=show '2/left/background_jobs'=show '2/left/status'=show
    #last_prompt_dir=$PWD
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${DOTFILES:-"${HOME}/.dotfiles"}/.p10k.zsh

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
