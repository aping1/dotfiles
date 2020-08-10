
if exists("g:loaded_custom_coc")
    finish
endif
let g:loaded_coc= 1


if executable('javascript-typescript-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'javascript-typescript-server',
                \ 'cmd': {server_info->['javascript-typescript-server']},
                \ 'whitelist': ['javascript', 'javascriptjsx', 'jsx']
                \ })
else
    echomsg "pyls is not available"
" \ 'whitelist': ['javascript', 'javascriptjsx']
endif
if executable('vim-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'vim-language-server',
                \ 'cmd': {server_info->['vim-language-server']},
                \ 'whitelist': ['vim',]
                \ })
else
    echoerr "vim-language-server is not available"
endif
if executable('pyls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python', 'ipython'],
                \ })
else
    echomsg "pyls is not available"
endif


