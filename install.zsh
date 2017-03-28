#!/bin/zsh

# Change shell for current user to zsh
if [ ! "$SHELL" = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# remove old dot files
dotfiles='''~/.gitconfig
~/.gitignore_global
~/.tmux.conf
~/.vimrc
~/.zshrc
~/.zpreztorc
'''

tar cvzf ~/dotfile.backup.$(date '+%F').tar.gz ${dotfiles}
rm ~/.gitconfig
rm ~/.gitignore_global
rm ~/.tmux.conf
rm ~/.vimrc
rm ~/.zshrc
rm ~/.zpreztorc

rsync -a .tmux ~/.dotfiles/tmux && rm -rf ~/.tmux || { echo "Cannot finish installed tmux sync" && return; }
rsync -a ~/.vim ~/.dotfiles/vim && rm -rf ~/.vim || { echo "Cannot finish installed vim sync" && return; }
# link new dot files
ln -s ~/.dotfiles/gitconfig               ~/.gitconfig
ln -s ~/.dotfiles/gitignore_global        ~/.gitignore_global
ln -s ~/.dotfiles/tmux.conf               ~/.tmux.conf
ln -s ~/.dotfiles/tmux                  ~/.tmux
ln -s ~/.dotfiles/vimrc                   ~/.vimrc
ln -s ~/.dotfiles/
ln -s ~/.dotfiles/zshrc                   ~/.zshrc
ln -s ~/.dotfiles/.zpreztorc              ~/.zpreztorc

# Do special to sync sublime settings on OS X
if [[ "$OSTYPE" =~ "darwin" ]]; then
  rm ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

  ln -s ~/.dotfiles/settings/SublimeText/User      ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi


# install powerline fonts
~/.dotfiles/powerline-fonts/install.sh

# TODO: Install vim-solarized8
# TODO: Install https://github.com/gabrielelana/awesome-terminal-fonts 
# TODO: Install .zpreztorc
