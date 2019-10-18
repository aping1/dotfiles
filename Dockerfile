FROM linuxbrew/brew as brew
RUN apt-get update \
	&& apt-get install -y --no-install-recommends software-properties-common \
	&& add-apt-repository -y ppa:git-core/ppa \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		bzip2 \
		ca-certificates \
		curl \
		file \
		fonts-dejavu-core \
		g++ \
		git \
		locales \
		make \
		openssh-client \
		patch \
		sudo \
		uuid-runtime \
        zsh \
	&& rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m user\
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER user
WORKDIR /home/user
ENV PATH="/home/user/linuxbrew/Homebrew/Library/bin/:$PATH"
RUN sudo chown -R "$(whoami)" "$(brew --prefix)"
RUN echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.profile
RUN git --bare clone https://www.github.com/aping1/dotfiles.git dotfiles.git 
RUN brew install git python@2 python@3
RUN bash -x .dotfiles/boostrap.sh
RUN brew bundle install --file=".dotfiles/Brewfile"
ENV USER=user
ENV SHELL=/usr/bin/bash
LABEL name=dotfiles

