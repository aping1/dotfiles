alias pip_location='python -m pip show pip | awk "/Location: /{print \$2}"'
alias pip3_location='python -m pip show pip | awk "/Location: /{print \$2}"'
function dev_init () {
    printf -- 'Installing to: '
    pip3_location
    python3 -m pip install pyflakes pylint black mypy
}
