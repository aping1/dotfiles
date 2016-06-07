
set-name() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
            tmux rename-window "$(echo $* | cut -d . -f 1)"
            tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        error "Uname to set window name: Not running in tmux"
    fi
}
