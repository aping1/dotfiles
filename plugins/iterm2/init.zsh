#!/bin/bash
_ITERM_HOOKS_H=1
# tmux requires unrecognized OSC sequences to be wrapped with DCS tmux;
# <sequence> ST, and for all ESCs in <sequence> to be replaced with ESC ESC. It
# only accepts ESC backslash for ST.
function _iterm_hooks_print_osc() {
    if [[ $TERM =~ ^xterm ]] ; then
        printf "\033Ptmux;\033\033]"
    else
        printf "\033]"
    fi
}

# More of the tmux workaround described above.
function _iterm_hooks_print_st() {
    if [[ $TERM =~ ^xterm ]] ; then
        printf "\a\033\\"
    else
        printf "\a"
    fi
}

function _iterm_hooks_set_iterm_name() {
  mode=$1; shift
  printf '\033Ptmux;\033\033]%s;%s\a\033\\' ${mode} "$@"

    #_iterm_hooks_print_osc && printf "$mode;$@" && _iterm_hooks_print_st
}

function _iterm_hooks_rename_both () {
    _iterm_hooks_set_iterm_name 0 $@;
}
function _iterm_hooks_rename_tab () {
    _iterm_hooks_set_iterm_name 1 $@;
}
function _iterm_hooks_rename_window () {
    _iterm_hooks_set_iterm_name 2 $@;
}


function _iterm_hooks_start_bounce() {
  _iterm_hooks_print_osc
  printf "1337;RequestAttention=1"
  _iterm_hooks_print_st
}

function _iterm_hooks_stop_bounce() {
  _iterm_hooks_print_osc
  printf "1337;RequestAttention=0"
  _iterm_hooks_print_st
}

function _iterm_hooks_fireworks() {
  _iterm_hooks_print_osc
  printf "1337;RequestAttention=fireworks"
  _iterm_hooks_print_st
}

