if exists("g:loaded_custom_coc")
  finish
endif
let g:loaded_custom_coc= 1
let g:coc_disable_startup_warning = 1

" We'll use coc lsp
augroup PYONLY
  au FileType python let g:ale_disable_lsp = 1
  set complete-=t
augroup END

"" for nvim lsp, for coc, we will use the install list
augroup LSPREG
if exists('*lsp#register_server')
  if executable('javascript-typescript-server')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'javascript-typescript-server',
          \ 'cmd': {server_info->['javascript-typescript-server']},
          \ 'whitelist': ['javascript', 'javascriptjsx', 'jsx']
          \ })
    "    else
    "        echomsg "javascript-typescript-server is not available"
    "    " \ 'whitelist': ['javascript', 'javascriptjsx']
  endif
  if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pysl']},
          \ 'whitelist': ["python", "ipython", "ipynb"],
          \ })
  else
    echomsg "pyls is not available"
  endif
  if executable('ccls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'ccls',
          \ 'cmd': {server_info->['ccsl']},
          \ 'whitelist': ["c", "cpp", "objc", "objcpp"],
          \ })
    "    else
    "        echomsg "ccls is not available"
  endif
  if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info->['gopls']},
          \ 'whitelist': ["go"],
          \ })
    "    else
    "        echomsg "gopls is not available"
  endif
endif
augroup END

" Extensions. Some need configuration. 
" coc-java needs a valid JVM filepath defined in coc-settings
" coc-ccls needs ccls (available on aur)
" coc-eslint needs eslint npm package installed globally
" Note: 
"   Moved :coc_global_extensions /Users/aping1/.dotfiles/config/nvim/after/plugin/coc.vim|| 169

augroup after_coc
  autocmd!
  " setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"""""""""""""""""
"Nerd Commenter "
"""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
