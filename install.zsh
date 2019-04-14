#!/usr/bin/env zsh
# some sanity check
setopt xtrace


# install .z 
# TOOD: Run vim +BundleInstall +Qall

unsetopt function_argzero

# Requerys formst
setopt PROMPT_SUBST
export DOTFILES=${(%):-$(realpath "${(%):-%x}")}
export DOTFILES=${DOTFILES:h}
export DOTFILES_SCRIPTPATH="$(dirname "$SCRIPT")"

: "${DOTFILES:="$HOME/.dotfiles"}"
: "${DEPFILES:="$HOME/.dotfiles/deps"}"

mkdir -p $HOME/.config/

# Absolute path this script is in, thus /home/user/bin
# link new dot files
#
pushd ${DOTFILES} 
git submodule init && submodule update
popd
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
setopt GLOB_SUBST
echo ${PWD}
_TMPR=$(mktemp /tmp/tmp_scripts_$(date '+%s')_XXXX || echo ./temp_script.tmp)
_TMP_DIFF=$(mktemp /tmp/tmp_diff_$(date '+%s')_XXXX || echo ./temp_diff.tmp)
printf '#!/usr/bin/env bash\n' >>${_TMPR}
printf 'cd ${HOME}\n' >>${_TMPR}
# printf 'set -e' >>${_TMPR}

# for each row in .dotfiles
sed -r 's/#.*$//g' ${DOTFILES%/}/.dotfiles | sed '/^$/d;'  | while read GLOB DEST; do
	# for each glob, dest
	[[ ${_DEBUG} ]] && printf 'DOTFILES: %s GLOB: %s DEST: %s\n' "${DOTFILES%/}"  "${GLOB}"  "${DEST}"  >&2
	## Check if the glob is a dir
	_SRC="${DOTFILES}/${GLOB%/}"
	if [[ -d ${DOTFILES%/}/${GLOB%/} && ${DEST} ]]; then
		declare -a filelist=($(ls -l ${DOTFILES%/}/${GLOB} | awk '{print $NF}'))
		# create a link to it as is
		printf -- '[[ -e "${DEST:h}" ]] || mkdir -p %s\n' "${DEST:h}"
		echo ln -sv "${_SRC:a}" "${DEST}"
	else
		# Glob expansion
		ls -l ${DOTFILES%/}/${GLOB} | awk '{print $NF}' | \
			while read this; do
				rel_this="${this##"${PWD}/"}"
				DEST=${HOME%/}/${DEST:-${rel_this:t}}
				if [[ -e $DEST ]] ; then
				   # If the same or link then rm
				   if [[  -h "${DEST}" ]] || cmp -s "${this}" "${DEST}" ; then
					echo "[No-op] ${DEST} ${HOME%/}/${rel_this}"  >&2
				     # they are identical, remove the bad one
				     rm -v "${DEST}" >&2
				   elif [[ -f ${DEST} ]]; then
					printf '%s vs %s\n' ${rel_this} ${rel_this:t} >&2
					# Make the dff additive
					diff -wud ${rel_this} ../${rel_this:t} | sed -E 's/^-([^-]|$)/ \1/g' |  tee /dev/stderr >  "${_TMP_DIFF}-${rel_this:t}"  
					# rediff compat not implemented
					# cat =(rediff "${_TMP_DIFF}-${rel_this:t}" ) | tee "${_TMP_DIFF}-${rel_this:t}"   >&2
				     printf -- 'cd %s && git apply -p1 -R %s || echo Apply failed for $? 1\n' "${DOTFILES}"  "${_TMP_DIFF}-${rel_this:t}"  
				     printf -- '( cd %s; git diff HEAD -- %s; printf "Revert[Y/n]?" && read -n 1 e; if [[ ${e} =~ [yY] ]]; then git checkout HEAD  -- %s; else rm -i %s; fi)\n' "${DOTFILES}" "${this}" "${this}" "${DEST}"
				   else
				   	printf 'Failed to install %s %s: Unknown filetype\n' "${DOTFILES%/}/${GLOB%/}" "${DEST}" >&2
			           fi
				   #printf 'Failed to install %s %s: exists\n' "${DOTFILES%/}/${GLOB%/}" "${DEST}" >&2
				fi
				## Doing it
				echo ln -sv .dotfiles/"${rel_this}" "$( if [[ "${DEST}" ]] ; then printf '%s' "${DEST:a}"; fi )" 
			done
		unset DEST
	fi
done >> "${_TMPR}"

if ls ${_TMP_DIFF}*; then
	cat ${_TMP_DIFF}*
	echo '##############'
	cat ${_TMPR}
	exec bash -x "${_TMPR}" || echo "$?"
fi

