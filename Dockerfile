
FROM zshusers/zsh:master
LABEL name=dotfiles
RUN install_packages git
COPY . dotfiles
WORKDIR dotfiles
RUN git remote set-url local file://.dotfiles 
WORKDIR /root
# ENTRYPOINT ["git","clone","file://$HOME/dotfiles.git",".dotfiles"]
ENTRYPOINT zsh -l 
CMD ["/usr/bin/zsh","-l"]
