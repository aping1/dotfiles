
function setup_brew () {
    command -v brew || open https://brew.sh &>/dev/null || echo "Please get homebrew from https://brew.sh"
    brew install python3
    brew install pyenv
    ln -s $(brew --cellar python)/* ~/.pyenv/versions/
    brew install zsh
    brew install the_silver_searcher
    brew install psutils
    # Window manager and hotkeys
    brew tap koekeishiya/formulae
    brew install yabai 
    brew install khd
    # 
}

function setup_pip () {
    python -m pip install pynvim
    python -m pip install black mypy pylint
}

