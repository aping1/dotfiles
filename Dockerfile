ARG DOTFILES_REMOTE=${DOTFILES_REMOTE:-https://github.com/aping1/dotfiles.git}
ARG dotfiles_git_rev=$DOTFILES_GIT_REV
ARG git_branch=${DOTFILES_GIT_BRANCH:-master-12-mba}
ENV USER=user
ENV SHELL=/usr/bin/bash
LABEL name=dotfiles
ENV PATH="/home/user/linuxbrew/Homebrew/Library/bin/:$PATH"
FROM linuxbrew/brew as brew
RUN useradd -ms /bin/noshell git && mkdir -p ~/bin
RUN apt-get update \
	&& apt-get install -y --no-install-recommends software-properties-common \
	&& add-apt-repository -y ppa:git-core/ppa \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
        libncursesw5-dev \
		bzip2 \
		ca-certificates \
		curl \
		file \
		g++ \
		git \
		locales \
		make \
		openssh-client \
		patch \
		sudo \
		uuid-runtime \
        zsh \
        su-exec \
	&& rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m user\
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER user
WORKDIR /home/user
RUN su-exec "$(whoami)" chown -R "$(whoami)" "$(brew --prefix)"
# COPY [d]otfiles.git.tar.gz .
# RUN [[ -s dotfiles.git.tar.gz ]] && tar xvzf dotfiles.git.tar.gz
RUN test "-f ${HOME}/dotfiles.git" \
        && git clone --recursive --branch ${git_branch} file://${HOME}/dotfiles.git .dotfiles \
        || git clone --recursive --branch ${git_branch} ${DOTFILES_REMOTE} .dotfiles
WORKDIR /home/user/.dotfiles
RUN git check-ref-format ${dotfiles_git_rev} && git reset ${dotfiles_git_rev} || echo
RUN brew install git python@3
RUN bash -x .dotfiles/bootstrap.sh
RUN command -v nvim && nvim +'silent! PlugInstall --sync' +qall 
RUN command -v vim && vim +'silent! PlugInstall --sync' +qall
COPY . /home/user/.dotfiles

