
if ! command -v vimr &>/dev/null; then
    echo 'vimr not installed' >&2
    return 1
else 
    alias vimr='vimr --cur-env'
    alias vim='vimr'
fi
