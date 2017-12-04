#
#ENABLED=0
#
export _SCRIPT_DIR="$( cd ${SCRIPT_DIR:-"$(dirname "$0")"} &>/dev/null ; pwd -P )"

if  [[ ! -e ${HOME}/.config/direnv/direnvrc ]]; then
    echo creating
    mkdir -p ${HOME}/.config/direnv/
    cat > ${HOME}/.config/direnv/direnvrc << _EOF 
## THIS FILE IS GENERATED FROM .dotfiles/plugins
$(plugins=($(find "${HOME}/.dotfiles/plugins" \
    -maxdepth 2 -name "init.zsh" )); for plugin in $plugins; do\
    grep -q '^#*ENABLED=0' "$plugin" ||  printf '. %s\n' "$plugin"; done)
source "${_SCRIPT_DIR}/main.sh"
_EOF
fi

_direnv_hook() {
  eval "$(direnv export zsh)";
}
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions+=_direnv_hook;
fi

