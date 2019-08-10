#!/bin/zsh
sentials() {
  emerge -av dev-util/cloc
  emerge -av dev-util/cmake
  emerge -av sys-apps/coreutils
  emerge -av dev-util/ctags
#  emerge -av cvi # core https://github.com/Xfennec/progress
#  emerge -av docker
#  emerge -av docker-compose
#  emerge -av docker-machine
  emerge -av dev-vcs/git
#  emerge -av gotags
#  emerge -av hr
#  emerge -av httpie
#  emerge -av icdiff
  emerge -av app-misc/jq
  emerge -av app-admin/lnav
#  emerge -av mercurial
  emerge -av sys-fs/ncdu
#  emerge -av node
  emerge -av app-arch/p7zip
#  emerge -av pstree # not in portage http://www.thp.uni-duisburg.de/pstree
  emerge -av pyenv # not in portage │https://github.com/yyuu/pyenv
#  emerge -av ranger
#  emerge -av rbenv
#  emerge -av ruby-build
#  emerge -av sqlite
#  emerge -av ssh-copy-id # Add a public key to a remote machine's authorized_keys file ttp://www.openssh.com/
  emerge -av  sys-apps/the_silver_searcher
  emerge -av app-misc/tmux
  emerge -av app-editors/vim
  emerge -av watch
  emerge -av app-shells/zsh
}
