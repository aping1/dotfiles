#!/usr/bin/env zsh
#
#
_fbtools_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
if [[ $0 == /bin/bash || ! ${_fbtools_local_script} =~ fbtools ]] ; then
    _fbtools_local_script=""
fi
#source "${_SCRIPT_DIR}/tasks/init.zsh"

declare -a plugins
source "${_fbtools_local_script:=${HOME}/.dotfiles/plugins/fbtools}/utils.zsh"
plugins=( $(find "${_fbtools_local_script}"  -mindepth 2 -name "init.zsh" 2>/dev/null ) )
for PLUGIN_FILE in ${plugins[@]}; do
    #printf "Sourcing ${PLUGIN_FILE}..."
    source "${PLUGIN_FILE}"
done

# FBONLY scm-prompt
if [ -f /opt/facebook/hg/share/scm-prompt.sh ]; then
  source /opt/facebook/hg/share/scm-prompt.sh
  #zstyle ':vcs_info:hg*+set-message:*' hooks scm-prompt
fi

if command -v zstyle &>/dev/null; then
zstyle ':vcs_info:hg+set-hgrev-format:*' hooks hg-storerev
#zstyle ':vcs_info:hg+set-message:*' hooks hg-branchhead
fi

# The hash is available in the hgrev-format hook, store a copy of it in the
# user_data array so we can access it in the second function
function +vi-hg-storerev() {
    user_data[hash]=${hook_com[hash]}
}

function update_iterm_title () {
    _iterm_hooks_rename_both "$(_fb_tmux_helper_get_session)"
}

# add-zsh-hook periodic update_iterm_title
