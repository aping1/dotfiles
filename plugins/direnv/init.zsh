
#ENABLED=0
#
# if [[ $0 == /bin/bash ]] ; then
#     _direnv_local_script=${HOME}/.dotfiles/plugins/direnv
#     exec $_direnv_local_script/init.zsh
# else
#     _direnv_local_script="$( cd $(realpath -e $(dirname "${0}")) &>/dev/null; pwd -P;)"
# fi
# if [[ ! ${_direnv_local_script} =~ direnv ]]; then
#     _direnv_local_script=${HOME}/.dotfiles/plugins/direnv

# if  [[ ! -e ${HOME}/.config/direnv/direnvrc ]]; then
#     mkdir -p ${HOME}/.config/direnv/
#     cat > ${HOME}/.config/direnv/direnvrc << _EOF 
## THIS FILE IS GENERATED FROM .dotfiles/plugins
# $(plugins=($(find "${HOME}/.dotfiles/plugins" \
#     -maxdepth 2 -name "init.zsh" )); for plugin in $plugins; do\
#     grep -q '^#*ENABLED=0' "$plugin" ||  printf '. %s\n' "$plugin"; done)
# source "${_direnv_local_script}/main.sh"
# _EOF
# fi

_direnv_hook() {
  eval "$(direnv export zsh)";
}
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions+=_direnv_hook;
fi

