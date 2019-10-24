FROM linuxbrew/brew as brew
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
		patch \
		sudo \
		uuid-runtime \
        zsh \
	&& rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m user\
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER user
ARG dotfiles_git_rev=$DOTFILES_GIT_REV
ARG git_branch=$DOTFILES_GIT_BRANCH
WORKDIR /home/user
ENV PATH="/home/user/linuxbrew/Homebrew/Library/bin/:$PATH"
RUN sudo chown -R "$(whoami)" "$(brew --prefix)"
COPY dotfiles.git.tar.gz .
RUN tar xvzf dotfiles.git.tar.gz
RUN git clone --recursive --branch ${git_branch} file://${HOME}/dotfiles.git .dotfiles
WORKDIR /home/user/.dotfiles
RUN git status
RUN git check-ref-format ${dotfiles_git_rev} && git reset --hard ${dotfiles_git_rev} || echo
WORKDIR /home/user/
RUN bash -x .dotfiles/bootstrap.sh
RUN zsh -i -c -- '-zplg-scheduler burst || echo -n'
RUN brew install git python@2 python@3
ENV USER=user
ENV SHELL=/usr/bin/bash
LABEL name=dotfiles

