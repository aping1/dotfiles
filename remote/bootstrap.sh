#!/bin/bash
if type tmux &>/dev/null; then

make - << _EOF
.tmux.conf:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
_EOF

fi
