#!/usr/bin/env zsh
# some sanity check
 setopt xtrace



unsetopt function_argzero

export DOTFILES=${(%):-$(realpath "${(%):-%x}")}
export DOTFILES=${DOTFILES:h}
export DOTFILES_SCRIPTPATH="$(dirname "$SCRIPT")"

: "${DOTFILES:="$HOME/.dotfiles"}"
: "${DEPFILES:="$HOME/.dotfiles/deps"}"

mkdir -p $HOME/.config/

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
pushd ${HOME}

install_zgen () {
	# ln -s "${DEPFILES}/zgen" "${HOME}/.zgen"
	cd "${DOTFILES}" &> /dev/null
	[[ -d "${HOME}/.zgen" ]] || git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
	grep 'source.*zgen.zsh' ${DOTFILES%/}/.zshrc || printf 'source "\${HOME}/.zgen/zgen.zsh"\n' >> ${DOTFILES%/}/.zshrc
}

install_zgen

if [[ "$OSTYPE" =~ "darwin" ]]; then 
	if [[ -e "${HOME}/Library/Containers/com.hogbaysoftware.TaskPaper3/Data/Library/Application Support/TaskPaper/StyleSheets/solarized_walton.less" ]]; then
		ln -s "${HOME}/Library/Containers/com.hogbaysoftware.TaskPaper3/Data/Library/Application Support/TaskPaper/StyleSheets/solarized_walton.less" "${DOTFILES}/themes/TaskPaper/solarized_walton.less"
	fi

	# Do special to sync sublime settings on OS X
	if [[ -d '~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User' ]]; then
	  rm ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	  ln -s ~/.dotfiles/settings/SublimeText/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	fi
fi


install_zprezto () {
	# prezto install (depricate for 'zgen prezto'
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	ln -s ${DOTFILES}/prezto "${ZDOTDIR:-$HOME}/.zprezto"
}

# install powerline fonts
#~/.dotfiles/powerline-fonts/install.sh

# TODO: Install vim-solarized8 (Depricate vimrc)
# TODO: Install https://github.com/gabrielelana/awesome-terminal-fonts 
# TODO: Install .zpreztorc

[[ -x "${DEPFILES}/fonts/install.sh" ]] && . "${DEPFILES}/fonts/install.sh" && logger -s 'Finished installing install.sh'

## using .dotfiles
echo ${PWD}
_TMPR=$(mktemp /tmp/tmp_scripts_XXXX || echo ./this_tmp.tmp)
_TMPF=$(mktemp /tmp/tmp_diff_XXXX || echo ./this_tmp.tmp)
printf '#!/usr/bin/env bash\n' >>${_TMPR}
printf -- 'git apply -p6 --reject %s || exit 1\n' "${_TMPF}"  >>${_TMPR}
printf 'cd $HOME\n ' >>${_TMPR}

sed -r 's/#.*$//g' ${DOTFILES%/}/.dotfiles | sed '/^$/d;'  | while read GLOB DEST; do
	[[ ${_DEBUG} ]] && printf 'DOTFILES: %s GLOB: %s DEST: %s\n' "${DOTFILES%/}"  "${GLOB}"  "${DEST}"  >&2
	## Check if dir
	if [[ -d ${DOTFILES%/}/${GLOB%/} && ${DEST} ]]; then
		[[ -e ${DEST} ]] && printf 'Failed to install %s %s\n' "${DOTFILES%/}/${GLOB%/}" "${DEST}"
		echo ln -sv "${DOTFILES##"${HOME}/"}/${GLOB%/}" "${DEST}"
	else
		ls -l ${DOTFILES%/}/${GLOB} | awk '{print $NF}' | \
			while read this; do
				rel_this="${this##"${HOME}/"}"
				DEST=${HOME%/}/${DEST:-${rel_this:t}}
				[[ ${DEST} ]] && printf 'Failed to install %s %s: exists\n' "${DOTFILES%/}/${GLOB%/}" "${DEST}" >&2
				if [[ -e $DEST ]] ; then
				   # If the same or link then rm
			   	   if [[ -h ${DEST} ]] || cmp -s "${HOMe%/}/${rel_this}" "${DEST}" ; then
				     # a link exists at dest or they are identical
				     echo "[No-op] ${DEST} ${HOME%/}/${rel_this}"  >&2
				   else 
				     # otherwise ${DEST} exists
				     #diff -ud "${this}" "${DEST}" | sed 's/-[^-](.*)/ $1/g' |  grep '^\(+\|$\|\ \|--\)' >> "${_TMPF}" 
				     diff -ud "${this}" "${DEST}" >> "${_TMPF}" 
				      printf 'Failed to install %s %s: exists\n' "${DOTFILES%/}/${GLOB%/}" "${DEST}" >&2
			   	 	printf -- 'rm -i %s\n' "${DEST}"
				     continue
			           fi
				fi
				## Doing it
				echo ln -sv "${rel_this}" "$( if [[ "${DEST}" ]] ; then printf '%s' "${DEST:a}"; fi )" 
			done
	fi
done >> "${_TMPR}"

if [[ ! -s ${_TMPF} ]]; then
    printf 'Empty file %s\n' "${_TMPF}"
    [[ ${_TMPF:t} =~ ^tmp_ && ! ${NOCLEAN:="N"} =~ [Yy] ]] && rm ${_TMPF} 
else	
	cat ${_TMPF}
	echo '##############'
	cat ${_TMPR}
	exec bash -x "${_TMPR}" || echo "$?"
fi

