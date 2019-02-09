#!/usr/bin/env zsh
if [[ ${DISTRO} == 'DARWIN' ]] && zgen saved ; then
	[[ -e /usr/local/lib/zpython ]] || brew install zpython
fi
module_path=($module_path /usr/local/lib/zpython)
zmodload zpython

