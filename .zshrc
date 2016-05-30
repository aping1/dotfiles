source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
#antigen bundle history
antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle kennethreitz/autoenv
#antigen bundle git
#antigen theme nfarrar/oh-my-powerline oh-my-powerline
#antigen theme https://gist.github.com/3712874.git agnoster
source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
bindkey -v

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


#export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
#export PATH=$(brew --prefix)/bin/:$PATH
