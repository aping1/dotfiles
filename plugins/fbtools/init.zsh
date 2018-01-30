#!/usr/bin/env zsh
#
#
export _SCRIPT_DIR="$( cd ${SCRIPT_DIR:-"$(dirname "$0")"} &>/dev/null ; pwd -P )"
#source "${_SCRIPT_DIR}/tasks/init.zsh"

declare -a plugins
source "${_SCRIPT_DIR}/utils.zsh"
plugins=( $(find "${_SCRIPT_DIR}"  -mindepth 2 -name "init.zsh" 2>/dev/null ) )
for PLUGIN_FILE in ${plugins[@]}; do
    #printf "Sourcing ${PLUGIN_FILE}..."
    source "${PLUGIN_FILE}"
done

# FBONLY scm-prompt
if [ -f /opt/facebook/hg/share/scm-prompt.sh ]; then
  source /opt/facebook/hg/share/scm-prompt.sh
  #zstyle ':vcs_info:hg*+set-message:*' hooks scm-prompt
fi


zstyle ':vcs_info:hg+set-hgrev-format:*' hooks hg-storerev
#zstyle ':vcs_info:hg+set-message:*' hooks hg-branchhead

# The hash is available in the hgrev-format hook, store a copy of it in the
# user_data array so we can access it in the second function
function +vi-hg-storerev() {
    user_data[hash]=${hook_com[hash]}
}

if [[ -d /opt/facebook/hg/share/zsh/site-functions ]]; then
    fpath+="/opt/facebook/hg/share/zsh/site-functions"
fi

function dev_server () {
    DEV_SERVER="$(host $(whoami).sb | head -n1 )"
    if ! grep -qi NXDOMAIN <<< "$DEV_SERVER" ; then
        [[ ${DEV_SERVER} ]] || return 1
        DEV_SERVER="$(echo "${DEV_SERVER}" | awk '{print $NF}' | sed 's/\.$//g')"
        printf "%s\n" "${DEV_SERVER}"
    fi
    [[ ${DEV_SERVER} ]] || return 2
}


export FBANDROID_DIR=/Users/aping1/fbsource/fbandroid
alias quicklog_update=/Users/aping1/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools
