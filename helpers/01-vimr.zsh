
if ! command -v vimr &>/dev/null; then
    echo 'vimr not installed' >&2
    return 1
else 
    alias vimr='vimr --cur-env --nvim'
    alias vim='vimr'
fi
