export SPACESHIP_PROMPT_ORDER=(
time        # Time stamps section (Disabled)
vi_mode       # Vi-mode indicator 
user          # Username section
dir           # Current directory section
host          # Hostname section
wip
git           # Git section (git_branch + git_status)
hg            # Mercurial section (hg_branch  + hg_status)
package     # Package version (Disabled)
# node          # Node.js section
git_last_commit # Last commit on branche
ruby          # Ruby section
# elixir        # Elixir section
xcode       # Xcode section (Disabled)
# swift         # Swift section
golang        # Go section
# php           # PHP section
# rust          # Rust section
# haskell       # Haskell Stack section
# julia       # Julia section (Disabled)
docker      # Docker section (Disabled)
# aws           # Amazon Web Services section
venv          # virtualenv section
# conda         # conda virtualenv section
pyenv         # Pyenv section
# dotnet        # .NET section
# ember       # Ember.js section (Disabled)
# kubecontext   # Kubectl context section
terraform     # Terraform workspace section
exec_time     # Execution time
# battery       # Battery level and status
jobs          # Background jobs indicator
char          # Prompt character
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX="${SPACESHIP_TIME_PREFIX:-"at "}\uf017 "
SPACESHIP_GIT_LAST_COMMIT_SHOW=true
SPACESHIP_VI_MODE_NORMAL="NORMAL"
SPACESHIP_VI_MODE_INSERT=INSERT
SPACESHIP_VI_MODE_COLOR=green

SPACESHIP_EXIT_CODE_SHOW=true

SPACESHIP_EXIT_CODE_PREFIX=""
SPACESHIP_EXIT_CODE_SYMBOL="\uf071"

# USER
SPACESHIP_USER_PREFIX="i am" # remove `with` before username
SPACESHIP_USER_SUFFIX="@" # remove space before host

# HOST
# Result will look like this:
#   username@:(hostname)
SPACESHIP_HOST_PREFIX="@:("
SPACESHIP_HOST_SUFFIX=") "

# DIR
SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory

# GIT
# Disable git symbol
SPACESHIP_GIT_SYMBOL="" # disable git prefix
SPACESHIP_GIT_BRANCH_PREFIX="" # disable branch prefix too
# Wrap git in `git:(...)`
SPACESHIP_GIT_PREFIX='git:('
SPACESHIP_GIT_SUFFIX=") "
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name
# Unwrap git status from `[...]`
SPACESHIP_GIT_STATUS_PREFIX=""
SPACESHIP_GIT_STATUS_SUFFIX=""

# NODE
SPACESHIP_NODE_PREFIX="node:("
SPACESHIP_NODE_SUFFIX=") "
SPACESHIP_NODE_SYMBOL=""

# RUBY
SPACESHIP_RUBY_PREFIX="ruby:("
SPACESHIP_RUBY_SUFFIX=") "
SPACESHIP_RUBY_SYMBOL=""

# XCODE
SPACESHIP_XCODE_PREFIX="xcode:("
SPACESHIP_XCODE_SUFFIX=") "
SPACESHIP_XCODE_SYMBOL=""

# SWIFT
SPACESHIP_SWIFT_PREFIX="swift:("
SPACESHIP_SWIFT_SUFFIX=") "
SPACESHIP_SWIFT_SYMBOL=""

# GOLANG
SPACESHIP_GOLANG_PREFIX="go:("
SPACESHIP_GOLANG_SUFFIX=") "
SPACESHIP_GOLANG_SYMBOL=""

# DOCKER
SPACESHIP_DOCKER_PREFIX="docker:("
SPACESHIP_DOCKER_SUFFIX=") "
SPACESHIP_DOCKER_SYMBOL=""

# VENV
SPACESHIP_VENV_PREFIX="venv:("
SPACESHIP_VENV_SUFFIX=") "

# PYENV
SPACESHIP_PYENV_PREFIX="python:("
SPACESHIP_PYENV_SUFFIX=") "
SPACESHIP_PYENV_SYMBOL=""


SPACESHIP_WIP_PREFIX="${SPACESHIP_WIP_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_WIP_SUFFIX="${SPACESHIP_WIP_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_WIP_SYMBOL="${SPACESHIP_WIP_SYMBOL="🚧 "}"
SPACESHIP_WIP_TEXT="${SPACESHIP_WIP_TEXT="WIP!!! "}"
SPACESHIP_WIP_COLOR="${SPACESHIP_WIP_COLOR="red"}"

spaceship_wip() {
  [[ $SPACESHIP_WIP_SHOW == false ]] && return

  spaceship::is_git || return
  spaceship::exists work_in_progress || return

  if [[ $(work_in_progress) == "WIP!!" ]]; then
    # Display WIP section
    spaceship::section \
      "$SPACESHIP_WIP_COLOR" \
      "$SPACESHIP_WIP_PREFIX" \
      "$SPACESHIP_WIP_SYMBOL" \
      "$SPACESHIP_WIP_TEXT" \
      "$SPACESHIP_WIP_SUFFIX"
  fi
}

SPACESHIP_GIT_LAST_COMMIT_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_GIT_LAST_COMMIT_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_GIT_LAST_COMMIT_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_GIT_LAST_COMMIT_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_GIT_LAST_COMMIT_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"

spaceship_git_last_commit() {
  [[ $SPACESHIP_GIT_LAST_COMMIT_SHOW == false ]] && return

  spaceship::is_git || return

  local 'git_last_commit_status'
  git_last_commit_status=$(git log --pretty='format:%s 🕑 %cr' 'HEAD^..HEAD' | head -n 1)

  [[ -z $git_last_commit_status ]] && return

  spaceship::section \
    "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL$git_last_commit_status" \
    "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX"

}
