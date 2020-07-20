"delete the following line if you don't want to have enhanced colors
let g:doxygen_enhanced_color=1
runtime! syntax/doxygen.vim
syn region doxygenComment matchgroup=pythonString start=+[uU]\=\z('''\|"""\)+ end="\z1" contains=doxygenSyncStart,doxygenStart,doxygenTODO keepend fold containedin=pythonString


