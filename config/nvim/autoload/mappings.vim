if exists("g:loaded_mappings)
    finish
endif
let g:loaded_mappings= 1

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

" use tab
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    if exists('*coc#refresh')
    call coc#refresh()
    endif
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction"}}}
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()

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
