#!/usr/bin/env zsh
#
#
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

# export ANDROID_SDK=/opt/android_sdk
# export ANDROID_NDK_REPOSITORY=/opt/android_ndk
# export ANDROID_HOME=${ANDROID_SDK}
# export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

# export ADMIN_SCRIPTS=/mnt/vol/engshare/admin/scripts/

function update_iterm_title () {
    _iterm_hooks_rename_both "$(_fb_tmux_helper_get_session)"
}
# add-zsh-hook periodic update_iterm_title


