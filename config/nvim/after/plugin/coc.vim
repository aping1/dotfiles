if exists("g:loaded_custom_coc")
    finish
endif
let g:loaded_custom_coc= 1

" We'll use coc lsp
augroup PYONLY
au FileType python let g:ale_disable_lsp = 1
set complete-=t
augroup END

" for nvim lsp, for coc, we will use the install list
if exists('*lsp#register_server')
    if executable('javascript-typescript-server')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'javascript-typescript-server',
                    \ 'cmd': {server_info->['javascript-typescript-server']},
                    \ 'whitelist': ['javascript', 'javascriptjsx', 'jsx']
                    \ })
    else
        echomsg "javascript-typescript-server is not available"
    " \ 'whitelist': ['javascript', 'javascriptjsx']
    endif
    if executable('pyls')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': {server_info->['pysl']},
                    \ 'whitelist': ["python", "ipython", "ipynb"],
                    \ })
    else
        echomsg "pyls is not available"
    endif
    "if executable('ccls')
    "    au User lsp_setup call lsp#register_server({
    "                \ 'name': 'ccls',
    "                \ 'cmd': {server_info->['ccsl']},
    "                \ 'whitelist': ["c", "cpp", "objc", "objcpp"],
    "                \ })
    "else
    "    echomsg "pyls is not available"
    "endif
endif

" Extensions. Some need configuration. 
" coc-java needs a valid JVM filepath defined in coc-settings
" coc-ccls needs ccls (available on aur)
" coc-eslint needs eslint npm package installed globally
" Note: 
"   Moved /Users/aping1/.dotfiles/config/nvim/after/plugin/coc.vim|| 169
" let g:coc_global_extensions = [
      " \'coc-html', 
      " \'coc-xml', 
      " \'coc-java', 
      " \'coc-ccls', 
      " \'coc-powershell', 
      " \'coc-r-lsp', 
      " \'coc-vimlsp', 
      " \'coc-lua', 
      " \'coc-sql', 
      " \'coc-go', 
      " \'coc-css', 
      " \'coc-sh', 
      " \'coc-snippets',
      " \'coc-prettier',
      " \'coc-eslint',
      " \'coc-emmet',
      " \'coc-tsserver',
      " \'coc-translator',
      " \'coc-fish',
      " \'coc-docker',
      " \'coc-pairs',
      " \'coc-json',
      " \'coc-python',
      " \'coc-imselect',
      " \'coc-highlight',
      " \'coc-git',
      " \'coc-github',
      " \'coc-gitignore',
      " \'coc-emoji',
      " \'coc-lists',
      " \'coc-post',
      " \'coc-stylelint',
      " \'coc-yaml',
      " \'coc-template',
      " \'coc-utils'
      " \]


augroup after_coc
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
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
