if exists("g:loaded_custom_mappings")
    finish
endif
let g:loaded_custom_mappings= 1

" Semshi mapping
nmap <silent> <leader>rr :Semshi rename<CR>

nmap <silent> <Tab> :Semshi goto name next<CR>
nmap <silent> <S-Tab> :Semshi goto name prev<CR>

nmap <silent> <leader>c :Semshi goto class next<CR>
nmap <silent> <leader>C :Semshi goto class prev<CR>

nmap <silent> <leader>f :Semshi goto function next<CR>
nmap <silent> <leader>F :Semshi goto function prev<CR>

nmap <silent> <leader>ee :Semshi error<CR>
nmap <silent> <leader>ge :Semshi goto error<CR>

" Control-0
inoremap <silent><c-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><c-k> <C-R>=OmniPopup('k')<CR>

nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>


augroup vim_blacklist_blacklist
    autocmd!
    autocmd FileType python call s:SetupJedi()
    autocmd FileType * call s:ale_settings() 
augroup END

function! s:ale_settings()
    "set omnifunc=ale#completion#OmniFunc
    set completeopt-=preview
    set completeopt+=noselect
    set completeopt+=noinsert
    nmap <silent> gd :ALEGoToDefinitionInTab<CR> " because I prefer tabs
    nmap <silent> gr :ALEFindReferences<CR>
    nmap ]v :ALENextWrap<CR>
    nmap [v :ALEPreviousWrap<CR>
    nmap ]V :ALELast
    nmap [A :ALEFirst
    nmap K :ALEHover<CR>
    nmap <F8> <Plug>(ale_fix)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endfunction
if executable('ipython')
augroup IPRunMaps
    autocmd!
    autocmd FileType python nmap <silent> <c-s> <Plug>(IPy-Run)
    autocmd FileType python vmap <silent> <c-s> <Plug>(IPy-Run)
    autocmd FileType python nmap <silent> <c-}> <Plug>(IPy-RunCell)
    autocmd FileType python nmap <silent> <leader> <c-}> <Plug>(IPy-RunAll)
    autocmd FileType python map <silent> <leader> <c-c> <Plug>(IPy-Interrupt)
    autocmd FileType python imap <c-f> <Plug>(IPy-Complete)
    autocmd FileType python map <silent> <leader>? <Plug>(IPy-WordObjInfo)
augroup END
endif

function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction
" Control-0
inoremap <silent><c-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><c-k> <C-R>=OmniPopup('k')<CR>

"----------------------------------------------
" Plugin 'shugo/denite.nvim'
"----------------------------------------------
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'
endfunction


" plugin: Vista.vim
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista_fzf_preview = ['right:50%']
let g:vista_executive_for = {
            \ 'vim': 'ale',
            \ }
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
"let g:vista_default_executive = 'ctags'
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
            \   "function": "\uf794",
            \   "variable": "\uf71b",
            \   "default": "",
            \  }

function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
                \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
                \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" Shift Tab insterts '\t' c-I ^I 
inoremap <S-Tab> <C-V><Tab>

augroup vim_blacklist_blacklist
    autocmd!
    autocmd FileType python call s:SetupJedi()
    autocmd FileType * call s:ale_settings() 
augroup END
