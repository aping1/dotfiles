
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
    dir
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
    # When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
  # icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  # typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Instant prompt mode.
  #
  #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
  #              it incompatible with your zsh configuration files.
  #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
  #              during zsh initialization. Choose this if you've read and understood
  #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
  #   - verbose: Enable instant prompt and print a warning when detecting console output during
  #              zsh initialization. Choose this if you've never tried instant prompt, haven't
  #              seen the warning, or if you are unsure what this all means.

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
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='﯏ '

  typeset -g POWERLEVEL9K_VCS_MODIFIED_ICON='✹'
  typeset -g POWERLEVEL9K_VCS_CONFLICT_ICON=''
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON='⇠'
  typeset -g POWERLEVEL9K_VCS_DIRTY_ICON=' '
  # typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='#' #<commit>
  typeset -g POWERLEVEL9K_VCS_UNMERGED_ICON='נּ '
  #typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_STASHES_ICON='裂'
  # Don't show staged, unstaged, untracked indicators.
  # Show '*' when there are staged, unstaged or untracked files.
  # Show '⇣' if local branch is behind remote.
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
  # Show '⇡' if local branch is ahead of remote.
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
  # Don't show the number of commits next to the ahead/behind arrows.
  typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=32
  # Don't count the number of unstaged, untracked and conflicted files in Git repositories with
  # more than this many files in the index. Negative value means infinity.
  #
  # If you are working in Git repositories with tens of millions of files and seeing performance
  # sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
  # of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
  # config: `git config bash.showDirtyState false`.n
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Don't show Git status in prompt for repositories whose workdir matches this pattern.
  # For example, if set to '~', the Git repository at $HOME/.git will be ignored.
  # Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

  # Disable the default Git status formatting.
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Install our own Git status formatter.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  # Enable counters for staged, unstaged, etc.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  # Icon color.
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$white0x
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$yellow0x
  # Custom icon.
  # typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom prefix.
  # typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '

  # Show status of repositories of these types. You can add svn and/or hg if you are
  # using them. If you do, your prompt may become slow even when your current directory
  # isn't in an svn or hg reposotiry.
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # These settings are used for repositories other than Git or when gitstatusd fails and
  # Powerlevel10k has to fall back to using vcs_info.
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=$green0x
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$green0x
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$red0x
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=$magenta0x
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$yellow0x

  # Remove space between '⇣' and '⇡'.
  # typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${P9K_CONTENT/⇣* ⇡/⇣⇡}'

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

  # Formatter for Git status.
  #
  # Example output: master ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
  #
  # You can edit the function to customize how Git status looks.
  #
  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
      # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local       meta='%f'     # default foreground
      local      clean='%F{'"${POWERLEVEL9K_VCS_CLEAN_FOREGROUND:-${grey0x}}"'}'   # green foreground
      local   modified='%F{'"${POWERLEVEL9K_VCS_MODIFIED_FOREGROUND:-${grey0x}}"'}' # yellow foreground
      local  untracked='%F{'"${POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND:-${grey0x}}"'}'    # blue foreground
      local conflicted='%F{'"${POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND:-${grey0x}}"'}'  # red foreground
    else
      # Styling for incomplete and stale Git status.
      local       meta='%F{'"${grey0x}"'}'  # grey foreground
      local      clean='%F{'"${grey0x}"'}'  # grey foreground
      local   modified='%F{'"${grey0x}"'}'  # grey foreground
      local  untracked='%F{'"${grey0x}"'}'  # grey foreground
      local conflicted='%F{'"${grey0x}"'}'  # grey foreground
    fi

    local res
    local where  # branch or tag
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${meta}"
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      res+="${meta}#"
      where=${(V)VCS_STATUS_TAG}
    fi

    # If local branch name or tag is at most 32 characters long, show it in full.
    # Otherwise show the first 12 … the last 12.
    # Tip: To always show local branch name in full without truncation, delete the next line.
    (( $#where > 32 )) && where[13,-13]="…"
    res+="${clean}${where//\%/%%}${meta}"  # escape %

    # Display the current Git commit if there is no branch or tag.
    # Tip: To always display the current Git commit, remove `[[ -z $where ]] &&` from the next line.
    [[ -z $where ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}${meta}"

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}${meta}"  # escape %
    fi

    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}${meta}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}${(g::)POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON:-'⇡'}${VCS_STATUS_COMMITS_AHEAD}${meta}"
    # ⇠42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}${(g::)POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON:-'⇠'}${VCS_STATUS_PUSH_COMMITS_BEHIND}${meta}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}${(g::)POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON:-'⇢'}${VCS_STATUS_PUSH_COMMITS_AHEAD}${meta}"
    # *42 if have stashes.
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}${(g::)POWERLEVEL9K_VCS_STASHES_ICON:-~}${VCS_STATUS_STASHES}${meta}"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}${meta}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}${(g::)POWERLEVEL9K_VCS_CONFLICT_ICON:-'!'}${VCS_STATUS_NUM_CONFLICTED}${meta}"
    # +42 if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${clean}${(g::)POWERLEVEL9K_VCS_MODIFIED_ICON}${VCS_STATUS_NUM_STAGED}${meta}"
    # !42 if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}${(g::)POWERLEVEL9K_VCS_DIRTY_ICON:-'x'}${VCS_STATUS_NUM_UNSTAGED}${meta}"
    # ?42 if have untracked files. It's really a question mark, your font isn't broken.
    # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
    # Remove the next line if you don't want to see untracked files at all.
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}:-'+'}${VCS_STATUS_NUM_UNTRACKED}${meta}"
    # "─" if the number of unstaged files is unknown. This can happen due to
    # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
    # than the number of files in the Git index, or due to bash.showDirtyState being set to false
    # in the repository config. The number of staged and untracked files may also be unknown
    # in this case.
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─${meta}"

    typeset -g my_git_format="$res"
  }
  functions -M my_git_formatter 2>/dev/null

  # User-defined prompt segments can be customized the same way as built-in segments.
  # typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=208
  # typeset -g POWERLEVEL9K_EXAMPLE_VISUAL_IDENTIFIER_EXPANSION='⭐'

  # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
  # when accepting a command line. Supported values:
  #
  #   - off:      Don't change prompt when accepting a command line.
  #   - always:   Trim down prompt when accepting a command line.
  #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
  #               typed after changing current working directory.
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
  # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
  # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
  # really need it.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
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
    p10k display '1|2|3/right'=show '2/left/time'=hide '2/left/status'=hide '2/left/background_jobs'=hide '2/right/dir'=hide
}
function p10k-on-post-prompt() {
    #[[ $POWERLEVEL9K_O $last_prompt_dir == $PWD ]] && \
    # hides 1st|2nd row for the right prompt segment
    # show time, background_jobs, stats on the left
    p10k display '1|2/right'=hide '2/left/time'=show '2/right/dir'=show '2/left/background_jobs'=show '2/left/status'=show
    #last_prompt_dir=$PWD
}

  # Example of a user-defined prompt segment. Function prompt_example will be called on every
  # prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
  # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and orange text greeting the user.
  #
  # Type `p10k help segment` for documentation and a more sophisticated example.
  # function prompt_example() {
  #   p10k segment -f 208 -i '⭐' -t 'hello, %n'
  # }

  # function prompt_customIcon() {
  #   currenttime=$(date +%H:%M)
  #
  #  if [[ "$currenttime" > "16:19" ]] ||  [[ "$currenttime" < "04:21" ]]; then
  #    # Weed
  #    p10k segment -f 070 -i 'ﲤ'
  #  else
  #    # Duck
  #    p10k segment -f 227 -i ''
  #  fi
  #  # # TS logo
  #  # p10k segment -f 027 -i 'ﯤ'
  #  # # Fire
  #  # p10k segment -f 160 -i ''
  #  # # Ice Cream
  #  # p10k segment -f 219 -i ''
  #}
  # User-defined prompt segments may optionally provide an instant_prompt_* function. Its job
  # is to generate the prompt segment for display in instant prompt. See
  # https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
  #
  # Powerlevel10k will call instant_prompt_* at the same time as the regular prompt_* function
  # and will record all `p10k segment` calls it makes. When displaying instant prompt, Powerlevel10k
  # will replay these calls without actually calling instant_prompt_*. It is imperative that
  # instant_prompt_* always makes the same `p10k segment` calls regardless of environment. If this
  # rule is not observed, the content of instant prompt will be incorrect.
  #
  # Usually, you should either not define instant_prompt_* or simply call prompt_* from it. If
  # instant_prompt_* is not defined for a segment, the segment won't be shown in instant prompt.
  #function instant_prompt_example() {
  #  # Since prompt_example always makes the same `p10k segment` calls, we can call it from
  #  # instant_prompt_example. This will give us the same `example` prompt segment in the instant
  #  # and regular prompts.
  #  prompt_example
  #}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
