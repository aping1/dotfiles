#!/usr/bin/env zsh
[[ "${_REALPWD="$(realpath ${PWD})"}" == "$(realpath ${HOME})" ]] || printf 'ERROR: pwd should be \${HOME} not \"%s\"' "${_REALPWD}"

# Sourcing files makes $0 the filename
unsetopt function_argzero

# Requerys formst
setopt PROMPT_SUBST
export DOTFILES=${(%):-"${${(%):-%x}:A}"}
export DOTFILES=${DOTFILES:h}
export DOTFILES_SCRIPTPATH="$(dirname "$SCRIPT")"

: "${DOTFILES:="$HOME/.dotfiles"}"
: "${DEPFILES:="$HOME/.dotfiles/deps"}"

[[ -d "${DOTFILES}" && -d "${DEPFILES}" ]] || exit 1

mkdir -p $HOME/.config/

# reinit submodules if needed
pushd ${DOTFILES}
if [[ ${DOTFILES_GIT_BRANCH} ]]; then
    git checkout ${DOTFILES_GIT_BRANCH#refs/}
fi
if [[ ${DOTFILES_GIT_REV} ]]; then
COUNTER=0
while [[ $COUNTER -lt 100 ]] &&  ! git reset --hard ${DOTFILES_GIT_REV}; do
    git pull
done
fi

git submodule status | grep -vE '^-' | wc -l | read num_uninit
if [[ ${num_uninit} && ${num_uninit} -gt 0 ]] ; then
    git submodule init \
    && git submodule update
fi
popd
pushd ${HOME}

## using .dotfiles
setopt GLOB_SUBST
# _TMPR=$(mktemp /tmp/tmp_scripts_$(date '+%s')_XXXX.sh || echo ./temp_script.tmp.sh)
# _TMP_DIFF=$(mktemp /tmp/tmp_diff_$(date '+%s')_XXXX || echo ./temp_diff.tmp)

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

# === Python Setup ===
[[ ${PYENV_ROOT:="${HOME}/.pyenv"} ]] && command -v brew \
    && cd ${PYENV_ROOT} \
    && ln -s $(brew --cellar python)/* "${PYENV_ROOT}/versions/"

function pip_from_dotfiles () 
{
    [[ -d ${DOTFILES} ]] || return 1
    [[ ${DOTFILES_SOURCE} ]] || export DOTFILES_SOURCE=( ${DOTFILES}/dotfiles ${DOTFILES}/${DISTRO:-posix}/dotfiles )
    cat ${DOTFILES_SOURCE[*]} | awk '/^pip/{ gsub(/\#.*$/, "",$0); $1=""; print; }' |  tr '"' "'" 
}

function pip_install_dotfiles() 
{
    if [[ ${DEBUG:-} =~ ^[Yy][e][s] ]]; then
        pip_from_dotfiles "${DOTFILES}/requirements.txt"
        [[ -s "${DOTFILES}/requirements.txt" ]] && cat "${DOTFILES}/requirements.txt" \
            || return 2
    fi
    # Dont warn if your DISTRO doesnt exist
    setopt nullglob 
    [[ ${DOTFILES_SOURCE} ]] || export DOTFILES_SOURCE=( ${DOTFILES}/dotfiles ${DOTFILES}/${DISTRO:-posix}/dotfiles )
    # If there are dotfiles
    if [[ ${#DOTFILES_SOURCE[@]} -ge 1 ]] ; then
        # Get the pyenv version
        _PYTHON_PYENV_VERSIONS=( $( pyenv whence python) )
        _PYTHONS=( $( which -a python{,3} | grep -v 'alias\|'"${PYENV_ROOT}" ) )
        for _PYENV_VERSION in ${_PYTHON_PYENV_VERSIONS[@]}; do
            _PY_VERSION=${PYENV_ROOT}/versions/${_PYENV_VERSION}/bin/python
            # Ensure pip 
            if [[ -x "${_PY_VERSION}" ]]; then 
                    _PYTHONS+=( ${_PY_VERSION} )
            fi
        done
        # 
        _PIPS=( $( which -a pip | grep -v "${PYENV_ROOT}" ) )
        for _PYTHON in ${_PYTHONS[@]}; do
            if [[ -x ${_PYTHON} ]]; then 
                version=$( ${_PYTHON} -c "import platform as p;print(p.python_version())" )
                sites=$( ${_PYTHON} -c "import site,json; print(' '.join(site.getsitepackages()))" )
                $([[ ${sites} && -w ${sites} ]] && printf -- sudo) \
                    ${_PYTHON} -m 'ensurepip'
                if [[ ${version} =~ ^3 ]]; then 
                    $([[ -w ${sites} ]] && echo -n sudo) \
                    ${_PYTHON} -m pip install -r <(pip_from_dotfiles) && continue
                elif [[ -x ${_PYTHON:h}/pip ]] ; then
                    _PIPS+=( ${_PYTHON:h}/pip )
                fi
            fi
            echo "could not ensure pip for ${_PYTHON}"
        done
        for _PY_VERSION in ${_PIPS[@]}; do
            $([[ -w ${sites} ]] && echo -n sudo) \
            ${_PY_VERSION} install -r <(pip_from_dotfiles) && continue
 
        done
    else
        return 3
    fi
}

# Install the pip
pip_install_dotfiles

# === vim setup ===
# Init vim and nvim even if aliased
if command -v vim &>/dev/null ; then
    NEXT_VIM=$(type -a vim | head -n2 | grep -A2 'alias' | tail -n1 | awk '{print $NF}')
    while !  [[ -x ${NEXT_VIM} ]] && ${NEXT_VIM} +'silent! PlugInstall --sync' +qall
fi
