
if exists("g:loaded_custom_coc")
    finish
endif
let g:loaded_custom_coc= 1


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

" use tab
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    if exists('*coc#refresh')
    call coc#refresh()
    endif
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction"}}}
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()


augroup CocResources
    autocmd!
    autocmd CursorHold * if exists('*CocActionAsync') | silent call CocActionAsync('highlight') | endif
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
    " refresh on backspace
    " inoremap <silent><expr> <TAB> pumvisible() ? : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()
augroup END

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr><ESC><ESC> pumvisible() ? "\<C-p>" : "\<C-h>"


