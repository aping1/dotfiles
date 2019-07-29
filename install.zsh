#!/bin/zsh
[[ "${_REALPWD="$(realpath ${PWD})"}" == "$(realpath ${HOME})" ]] || printf 'ERROR: pwd should be \${HOME} not \"%s\"' "${_REALPWD}"
unsetopt function_argzero

# Requerys formst
setopt PROMPT_SUBST
export DOTFILES=${(%):-"${${(%):-%x}:A}"}
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
_TMPR=$(mktemp /tmp/tmp_scripts_$(date '+%s')_XXXX.sh || echo ./temp_script.tmp.sh)
_TMP_DIFF=$(mktemp /tmp/tmp_diff_$(date '+%s')_XXXX || echo ./temp_diff.tmp)

printf -- 'Generating: %s\n' "${_TMPR}"

cat >> ${_TMPR} << _EOF
#!/usr/bin/env bash
cd \${HOME}
set -e
_EOF
# for each row in .dotfiles
function rel_path () {
    # Print the relative path from the second directory to the first,
    # defaulting the second directory to $PWD if none is specified.
    emulate -L zsh || return 1
    # rel $1 -> ($2 or pwd)
    # 
    [[ $1 != /* ]] && print $1 && return
    [[ -f $1 ]] && 3=$1:t 1=$1:h
    [[ -d $1 && -d ${2:=$PWD} ]] || return 1
    [[ $1 -ef $2 ]] && print ${3:-.} && return

    # The simplest way to eliminate symlinks and ./ and ../ in the paths:
    1=$(cd $1; pwd -r)
    2=$(cd $2; pwd -r)

    local -a cur abs
    cur=(${(s:/:)2})	# Split 'current' directory into cur
    abs=(${(s:/:)1} $3)	# Split target directory into abs

    # Compute the length of the common prefix, or discover a subdiretory:
    integer i=1
    while [[ i -le $#abs && $abs[i] == $cur[i] ]]
    do
        ((++i > $#cur)) && print ${(j:/:)abs[i,-1]} && return
    done

    2=${(j:/:)cur[i,-1]/*/..}	# Up to the common prefix directory and
    1=${(j:/:)abs[i,-1]}		# down to the target directory or file

    print $2${1:+/$1}
}


function handle_pathmatches() {
    # the dotfile we are referencing
    local this="${1}"
    # the dotfiles 
    [[ -n "${this}" ]] || return 2
    # The full path of of arg 1 != dotfiles or home
    # and it has to exists
    if [[ "${this:A}" -ef "${DOTFILES:A}" && "${this:A}" -ef "${HOME}" ]]; then
        return 2
    elif [[ ! -e "${this:A}" ]]; then
        printf -- 'Invalid source "%s" does not exist; \n' "${PWD}" "${this:a}" >&2
        return 3
    fi
    # get the relative path of the file we are linking to to hoee directory
    local rel_this="$(rel_path "${this:a}" "${HOME}")"
    # relative path of the source
    local rel_dest="$(rel_path "${this:a}" "${DOTFILES}")"
    # Dest is the home given DEST or $2 or $HOME/$(basename $1)
    local DEST=""
    local _FORCE_DIR=n
    # Destination will be the relative path of .dotfiles/<relative_dir> 
    DEST="$(rel_path "${2:-"${DOTFILES}/${rel_this:t}"}" "${DOTFILES}")"
    [[ ${DEST} ]] && printf 'Starting install %s -> %s \n' "${rel_this}" "${DEST}" >&2
    # if trailing slash then the dest it's a dir
    if [[ "${DEST}" != "${DEST%/}" ]]; then
        _FORCE_DIR=y
    elif [[ "${DEST}" =~ ^\.\./ ]]; then 
        # Relative path starts backwards  sois not a subset of DOTFILES
        return 5
    elif [[ "${DEST:A}" -ef "${HOME}" ]]; then 
        return 6
    elif [[ "${DEST:A}" -ef "${DOTFILES}" ]]; then 
        return 7
    fi
    # If directory not explicity asked for
    [[ ${_FORCE_DIR} != 'y' ]] && DEST="${HOME}/${DEST}"
    # exists but not a dir
    printf -- 'if [[ -e "%s" && ! -d "%s" ]]; then echo "[No-op] %s exists but is not a dir' "${DEST%/}" "${DEST}"
    # doesnt exists 
    printf -- 'elif [[ ! -e "%s" ]]; then mkdir -p %s; fi\n' "${DEST%/}" "${DEST}"
    #make it
    printf -- 'else; mkdir -p %s; fi\n' "${DEST}"
    printf 'Attempt to install %s -> %s [override %s]: ' "${rel_this}" "${DEST}" "${_FORCE_DIR}" >&2
    if [[ ${_FORCE_DIR} == 'y' || -d "${DEST}" ]]; then
        # if we are going to a dir
        if [[ -f "${this}" ]]; then
            ## linking from a file, We'll create a softlink in DEST directory
            printf 'will link file "%s" into dir %s \n' "${rel_dest}" "${DEST}" >&2
            if  [[ ! "${DEST:A}" -ef "${HOME}" ]]; then
                printf -- '[[ -e "%s" ]] && echo "Could not create base dir %s" || mkdir -p %s\n' "${DEST:A:h}" "${DEST:h}" "${DEST:h}"
            fi
        elif [[ -h "${this}" || "${DEST}" -ef "${this}" ]] ; then
            # we are trying to link to a link 
            echo "[No-op] ${rel_dest:A } ${DEST} "  >&2
        elif [[ -d ${DEST} && ${_FORCE_DIR} != y ]]; then
            printf 'will Remove "%s"  \n' "${DEST}" >&2
            printf -- 'rmdir "%s" || echo "noop";\n' "${DEST}"
        else
            printf 'Linking "%s" into dir %s \n' "${rel_dest:A}" "${DEST}" >&2
        fi 
        printf -- 'ln -sv "%s" "%s"; \n' "${rel_dest:A}" "${DEST}"
    elif [[ -h "${DEST}" || -f "${DEST}" ]]; then
        # Dest is a link or file
        if [[ -h "${DEST}" || "${DEST:A}" -ef "${rel_dest:A}" ]]; then
            # link to the same file exists, noop
            echo "[No-op] ${DEST} ${rel_this:a}"  >&2
        elif cmp -s "${this}" "${DEST}";  then
            # it's a link to a different file or files are identical, remove it
            printf 'Found existing dup, will Remove %s \n' "${DEST}" >&2
            printf -- 'rm -v %s && ln -sv "%s" "%s"; \n' "${DEST}" "${rel_this}" "${DEST}"
        else
            printf 'Linking "%s" into dir %s \n' "${rel_dest:A}" "${DEST}" >&2
        fi
    elif [[  -f "${DEST}" && -f "${this}" ]]; then
        # If dest is a regular file but are different
        printf 'Creating diff for %s vs %s\n' "${rel_this}" "${DEST}" >&2
        # Make the diff additive
        diff -wud "${this}" "${DEST}" | sed -E 's/^-([^-]|$)/ \1/g' | tee /dev/stderr >  "${_TMP_DIFF}-${this:t}"
        # rediff compat not implemented
        # cat =(rediff "${_TMP_DIFF}-${rel_this:t}" ) | tee "${_TMP_DIFF}-${rel_this:t}"   >&2
        # Apply diff
        printf -- 'cd %s && git apply -p1 -R %s || echo Apply failed for $? 1\n' "${DOTFILES}"  "${_TMP_DIFF}-${this:t}"
        # Show diff
        printf -- '( cd %s; git diff HEAD -- %s; printf "Revert[Y/n]?" && read -n 1 e; if [[ ${e} =~ [yY] ]]; then git checkout HEAD  -- %s; else rm -i %s; fi)\n' "${DOTFILES}" "${this}" "${this}" "${DEST}"
    elif [[ ! -e "${DEST}" ]]; then
        # if we arn't asking for directory and it doesnt esist 
        printf 'Dest "%s" does not exist\n' "${DEST}" >&2
        if [[ ${_FORCE_DIR} != 'y' || -d ${DEST:h} ]] && [[ ! "${DEST:h}" -ef "${HOME}" ]]; then
            printf -- '[[ -e "%s" ]] && echo "Not creating dir %s" || mkdir -p %s\n' "${DEST:h}" "${DEST:h}" "${DEST:h}"
        fi
        # Create a link
        printf -- 'ln -sv "%s" "%s"; \n' "${rel_this}" "${DEST}"
    else
        printf 'Failed to install %s %s: Unknown filetype\n' "${rel_this}" "${DEST}" >&2
    fi
}

# for eacch line <src:glob> <dest> <COMMAND>
sed -e 's/#.*$//' -e '/^$/d' "${DOTFILES%/}/.dotfiles" | while read GLOB DEST OTHER; do
    [[ ${_DEBUG} ]] && printf 'DOTFILES: %s GLOB: %s DEST: %s\n' "${DOTFILES%/}"  "${GLOB}"  "${DEST}"  >&2
    ## Check if the glob is a dir
    local GLOB_PATH=""
    _SRC=( ${~${GLOB_PATH:="${DOTFILES}/${GLOB%/}"}} )
    if [[ ${#_SRC} -gt 1 ]]; then
        # TODO: COMMAND: '{"do": "PWD={dotfiles} /bin/touch ${this} ${dest}"}'
        # var $1 := file in (.dotfiles)
        # var $2 := path to create a link at (not in .dotfiles)
        # $1:<FILE> ; create link to this file in $HOME as basename
        # $1:<DIR> dest:<DEST_PATH> <COMMAND> ; create link to dir in dest_path
        # $1:<FILE> dest:<DEST_PATH> <COMMAND> ; create a link in dest_path
        # [[ -h dest_path ]] pass; [[ -d [DESTPATH] ]] :
        # $1:<FILE> dest:<DEST_PATH>/ <COMMAND> ; create a link in dest_path
        # for each in glob, run the things against the dest folder
        autoload -U zargs
        zargs -r -i{} ${_SRC[*]} -- handle_pathmatches {} "${DEST%/}/"
    else
        handle_pathmatches "${_SRC}" "${DEST:a}"
    fi
done  >> "${_TMPR}"


if ls ${_TMP_DIFF}*; then
    echo "${_TMPR:A}"
    cat ${_TMPR}
    read 'cont?Exec[y/N] ##############'
    if [[ $cont =~ ^[Yy]?$ ]]; then
        exec bash -x "${_TMPR}" || echo "$?"
    fi
fi
