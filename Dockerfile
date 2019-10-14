FROM zshusers/zsh as zsh
FROM linuxbrew/brew as brew

COPY --from=zsh /usr/share/zsh /usr/share/
COPY --from=zsh /usr/lib/zsh /usr/lib/
COPY --from=zsh /usr/lib/zsh/ /usr/lib/zsh/
# Install portable-ruby and tap homebrew/core.
#
#
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
		curl \
	&& rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m user\
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER user
WORKDIR /home/user
ENV PATH="/home/user/linuxbrew/Homebrew/Library/bin/:$PATH"
RUN sudo chown -R "$(whoami)" "$(brew --prefix)"
RUN echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.profile
RUN brew install git python@2.7 python@3.7
ENV USER=us
ENV SHELL=/usr/bin/sh
LABEL name=dotfiles

