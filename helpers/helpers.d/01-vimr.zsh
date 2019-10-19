
if [[ ${DISTRO} == darwin ]] ; then
    if ! command -v brew; then
        brew cask install vimr
fi

if ! command -v vimr &>/dev/null; then
    echo 'vimr not installed' >&2
    return 1
else 
    alias vimr='vimr --cur-env --nvim'
    alias vim='vimr'
if
fi
