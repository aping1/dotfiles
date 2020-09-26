if exists("g:loaded_custom_mappings") && g:loaded_custom_mappings>0
    finish
endif
let g:loaded_custom_mappings=1

" Semshi mapping
function s:semshi_enable()
nmap <silent> <leader>sr :Semshi rename<CR>

nmap <silent> <leader>sn :Semshi goto name next<CR>
nmap <silent> <leader>sp :Semshi goto name prev<CR>

nmap <silent> <leader>sc :Semshi goto class next<CR>
nmap <silent> <leader>sC :Semshi goto class prev<CR>

nmap <silent> <leader>s] :Semshi goto function next<CR>
nmap <silent> <leader>s[ :Semshi goto function prev<CR>

nmap <silent> <leader>se :Semshi error<CR>
nmap <silent> <leader>sE :Semshi goto error<CR>
endfunction " end enable_semshi

" Control-0
inoremap <silent><c-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><c-k> <C-R>=OmniPopup('k')<CR>

nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>


augroup vim_blacklist_blacklist
    autocmd!
    autocmd FileType Python call <SID>semshi_enable()
    autocmd FileType Python set sw=4 
    autocmd FileType * call <SID>ale_settings() 
    autocmd FileType * call <SID>SetupJedicommands()
augroup END


" <leader>n: show the usage of a name in current file
" <leader>r: rename a nameexists('pyenv#python*') 
function! s:SetupJedicommands()
    let g:jedi#goto_command = "<leader>d"
    let g:jedi#goto_assignments_command = "<leader>g"
    let g:jedi#goto_stubs_command = "<leader>s"
    let g:jedi#goto_definitions_command = "<leader>R"
    " let g:jedi#documentation_command = "K"
    let g:jedi#usages_command = "<leader>n"
    let g:jedi#completions_command = "<C-Space>"
    let g:jedi#rename_command = "<leader>r"
endfunction

function! s:ale_settings()
    "set omnifunc=ale#completion#OmniFunc
    " preview will open a horz split
    set completeopt-=preview
    set completeopt+=noselect
    set completeopt+=noinsert
    nmap <silent> gd :ALEGoToDefinitionInTab<CR> " because I prefer tabs
    nmap <silent> gr :ALEFindReferences<CR>
    nmap ]v :ALENextWrap<CR>
    nmap [v :ALEPreviousWrap<CR>
    nmap ]V :ALELast
    nmap [V :ALEFirst
    nmap <leader> V :ALEHover<CR>
    nmap <F8> <Plug>(ale_fix)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endfunction

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


" use tab
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    if exists('*coc#refresh')
        call coc#refresh()
    endif
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction"}}}
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()

" shift+tab cycles backwards 
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

augroup CocResources
    autocmd!
    autocmd CursorHold * if exists('*CocActionAsync') | silent call CocActionAsync('highlight') | endif
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
    " refresh on backspace
    " inoremap <silent><expr> <TAB> pumvisible() ? : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()
augroup END

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr><ESC><ESC> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" Enter to confirm completion
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"


" Shift Tab insterts '\t' c-I ^I 
inoremap <S-Tab> <C-V><Tab>
inoremap  \\
noremap  \\

" vmap <silent> <Leader>qs :call Quote("'")<CR>
vmap <silent> <Leader>qd :call Quote('"')<CR>

" Vista
" Floating tag finder
nnoremap  <Leader>f  :Vista finder coc<cr>
" Opens tagbar on right side of screen
nmap <F4> :Vista!!<CR>

" This gets in the way of literal '\'
" inoremap <Leader> <space> <ESC>

" Lazydocker
nnoremap <silent> <Leader>ld :call ToggleLazyDocker()<CR>

" NERD Commenter
" Toggle comments in visual or normal mode
nnoremap <leader>nc :call NERDComment(0,"toggle")<cr>
vnoremap <leader>nc :call NERDComment(1,"toggle")<cr>
" Toggle a sexy comment
nnoremap <leader>ns :call NERDComment(0,"sexy")<cr>
vnoremap <leader>ns :call NERDComment(1,"sexy")<cr>
" append a  comment
nnoremap <leader>na :call NERDComment(0,"append")<cr>
vnoremap <leader>na :call NERDComment(1,"append")<cr>
" uncomment section
nnoremap <leader>nu :call NERDComment(0,"uncomment")<cr>
vnoremap <leader>nu :call NERDComment(1,"uncomment")<cr>
" invert comments
nnoremap <leader>ni :call NERDComment(0,"invert")<cr>
vnoremap <leader>ni :call NERDComment(1,"invert")<cr>
" comment section
nnoremap <leader>nn :call NERDComment(0,"comment")<cr>
vnoremap <leader>nn :call NERDComment(1,"comment")<cr>
"
"

" Git keybinds
" Git status
nnoremap  <Leader>gs  :Gstatus<cr>
" Git diff in split window
nnoremap  <Leader>gd  :Gdiffsplit<cr>
" Git commit
nnoremap  <Leader>gc  :Gcommit<cr>
" Git push 
nnoremap  <Leader>gP  :Gpush<cr>
" Git pull 
nnoremap  <Leader>gp  :Gpull<cr>
" Git move 
nnoremap  <Leader>gm  :Gmove<cr>
" Git merge 
nnoremap  <Leader>gM  :Gmerge<cr>
" browse current file on web
nnoremap  <Leader>gb  :Gbrowse<cr>
" browse current line on web
nnoremap  <Leader>gbl  :CocCommand git.browserOpen<cr>
" View chunk information in preview window. 
nnoremap  <Leader>gh  :CocCommand git.chunkInfo<cr>
" View commit information in preview window. 
nnoremap  <Leader>gsc  :CocCommand git.showCommit<cr>
" Toggle git gutter sign columns
nnoremap  <Leader>gg  :CocCommand git.toggleGutters<cr>
" Lazygit
nnoremap <silent> <Leader>lg :call ToggleLazyGit()<CR>

" Indent controls
" Reselect text ater indent/unindent.
vnoremap < <gv
vnoremap > >gv
" Tab to indent in visual mode.
vnoremap <Tab> >gv
" Shift+Tab to unindent in visual mode.
vnoremap <S-Tab> <gv

" Text alignment
nnoremap <Leader>Al :left<CR>
nnoremap <Leader>Ac :center<CR>
nnoremap <Leader>Ar :right<CR>
vnoremap <Leader>Al :left<CR>
vnoremap <Leader>Ac :center<CR>
vnoremap <Leader>Ar :right<CR>

" COC Keybinds
" Remap keys for gotos
map <leader>cd <Plug>(coc-definition)
nmap <leader>ct <Plug>(coc-type-definition)
nmap <leader>ci <Plug>(coc-implementation)
map <leader>cr <Plug>(coc-references)
" Remap for rename current word
nmap <leader>crn <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)
" Fix current line
nmap <leader>cfl  <Plug>(coc-fix-current)
" Using CocList
" Show all diagnostics
nnoremap  <Leader>cdi  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap  <Leader>ce  :<C-u>CocList extensions<cr>
" Show commands
nnoremap  <Leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <Leader>co  :<C-u>CocList outline<cr>
" Completion keybinds
"

let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 1  " Feel free to increase/decrease this value.
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
