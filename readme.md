# Allison Wampler's Dotfiles

# Info 

# Installation

    git clone --recursive  git@github.com:allisonmarw/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.zsh


# Modules

* awesome-terminal-fonts - Other patched fonts
* fonts - Powerline patched fonts
* powerline - powerline
* tpm - tmux plugin manager
* vim-solarized8 - solarized vim
* zgen - zgen for prezto

# Tmux tty limit
sometimes you'll get a message from tmux that will prevent you from opening windows 

    number of open files (per process; the tmux server uses several file descriptors per pane and per client)
    You can check this limit (”fds”; for the tmux server) with tmux run 'bash -c "ulimit -n"'.
    You can check an individual process’s fd usage with lsof -p $PID | wc -l.
    number of processes (per user)
    You can check this limit (anywhere, since it is effectively per-user) with bash -c "ulimit -u".
    You can check the number of your processes with ps -U $USER | wc -l.
    number of pseudo terminals (“ptys”; system-wide)
    You can check this limit (anywhere, it is system-wide) with sysctl kern.tty.ptmx_max.
    You can check the number of active ptys with something like echo /dev/ttys[0-9][0-9][0-9]* | wc -w.
    The forkpty message indicates that that problem is due to either the process or pty limit. Beyond that, individual tmux servers may also be running into their fd limits.

    All of these limits can be adjusted (some by ordinary users, others only by root). You may need to restart your tmux server(s) (I do not know of a way to get a server to adjust its own soft rlimits, so the only way to affect it is to (re)start it from a parent that has already adjusted its own limits). There are hard limits that even root can not change, but you probably will not need to go quite that far (yet

    It turns out the sysctl kern.tty.ptmx_max option was set to 127 which is pretty close to 125 panes I was running.
    Also since you narrowed the guess to this one I decided to update it first.

    If anyone stumbles on this issue later, this is how the setting is changed:

    $ sudo sysctl -w kern.tty.ptmx_max=256
