"
" ~/.vimrc (local shell)
"

set ruler
set ignorecase
set smartcase

set shell=/bin/bash
set encoding=utf8
set ambiwidth=double
set ffs=unix,dos,mac
set nobackup
set noswapfile
set incsearch
set title
set showmode
set wildmenu
" 2^31-1=2147483648
set history=9999

try
    set undodir=~/.vim_runtime/undodir
    set undofile
catch
endtry

set smarttab
set expandtab
set linebreak
set textwidth=0

" Disable case insensitive search and replace.
set noignorecase
set nosmartcase

set foldcolumn=2
" Fix up arrow not working in search.

set laststatus=2
set number

set ts=4
set sw=4
set ai
set hlsearch
set shiftround

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd TabEnter,BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:  autocmd BufReadPost * set norelativenumber
:augroup END

" -----
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("termguicolors"))
    set termguicolors
endif

set clipboard=unnamedplus

if exists("$VIRTUAL_ENV")
    let g:python_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), '\n', '', 'g')
    let g:python3_host_prog=g:python_host_prog
else
    let g:python_host_prog=substitute(system("which python3"), '\n', '', 'g')
    let g:python3_host_prog=g:python_host_prog
endif


call plug#begin('~/.config/nvim/plugged')

" --- Colorscheme(s) ---
Plug 'flazz/vim-colorschemes'
Plug 'iCyMind/NeoSolarized'
Plug 'jacoborus/tender.vim'
Plug 'rakr/vim-one'

" Vim exploration Modifications
Plug 'Shougo/denite.nvim'
Plug 'dunstontc/denite-mapping'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'numkil/ag.nvim'

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mg979/vim-visual-multi'

" Writing
Plug 'SidOfc/mkdx'
Plug 'itspriddle/vim-marked'
Plug 'gyim/vim-boxdraw'

" Version Control
Plug 'tpope/vim-fugitive'
" mecurial client
Plug 'ludovicchabant/vim-lawrencium'

Plug 'w0rp/ale'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'

" Linting, syntax, autocomplete, semantic highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Tools for repl
Plug 'Vigemus/impromptu.nvim'
Plug 'Vigemus/iron.nvim'

" Python 
Plug 'plytophogy/vim-virtualenv'
Plug 'lambdalisue/vim-pyenv'
Plug 'bfredl/nvim-ipy'
Plug 'janko/vim-test'


Plug 'mtikekar/nvim-send-to-term'

Plug 'tmhedberg/SimpylFold'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'ryanoasis/vim-devicons'



" Indent lines
Plug 'nathanaelkane/vim-indent-guides'
" Git gutter
Plug 'mhinz/vim-signify'
" Highlight colors
Plug 'ap/vim-css-color'


Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

call plug#end()
filetype plugin indent on     " required

let s:blacklist = ['nofile', 'help']


"----------------------------------------------
" Plugin: 'nathanaelkane/vim-indent-guides'
"----------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1

if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif
"----------------------------------------------
" Plugin: 'tpope/vim-obsession'
"----------------------------------------------
" Plugin: 'sakhnik/nvim-gdb'
"----------------------------------------------
" We're going to define single-letter keymaps, so don't try to define them
" in the terminal window.  The debugger CLI should continue accepting text commands.
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': 'u',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }

"----------------------------------------------
" Plugin: 'SidOfc/mkdx'
"----------------------------------------------
"
" fzf + mxdx
fun! s:MkdxGoToHeader(header)
    " given a line: '  84: # Header'
    " this will match the number 84 and move the cursor to the start of that line
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    " if the text is empty or no lnum is present, return the empty string
    if (empty(text) || empty(lnum)) | return text | endif

    " We can't jump to it if we dont know the line number so that must be present in the outpt line.
    " We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>

let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', '-', 'x'] } }

"----------------------------------------------
" colorscheme
"----------------------------------------------

" These lines setup the environment to show graphics and colors correctly.
set nocompatible

"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1

:au BufNewFile,BufRead *.jinja set filetype=jinja

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Reload .vimrc immediately when edited
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.

" Run lint on these file types.
"au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"
"au FileType json exe ":silent 1, $!jq . - 2> /dev/null"

set mouse+=a

imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" au BufNewFile *.py 0r ~/.vim/python.skel | let IndentStyle = "python"
"
au BufNewFile COMMIT_EDITING let syntax = diff

" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m

luafile $HOME/.config/nvim/iron.plugin.lua

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level


" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

"----------------------------------------------
" Plugin: 'Vigemus/iron.nvim'
"----------------------------------------------
luafile $HOME/.config/nvim/iron.plugin.lua

"----------------------------------------------
" Plugin: 'davidhalter/jedi-vim'
"----------------------------------------------
" disable autocompletion, we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
" <leader>n: show the usage of a name in current file
" <leader>r: rename a name

" let g:deoplete#sources#jedi#extra_path = ['/dev/shm/fbcode-vimcache']

if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
    if exists("$VIRTUAL_ENV")
        let g:python_host_prog=substitute(system("which -a python | head -n1 | tail -n1"), '\n', '', 'g')
        let g:python3_host_prog=substitute(system("which -a python3 | head -n1 | tail -n1"), '\n', '', 'g')
        let g:jedi#force_py_version='3'
    else
        let g:python_host_prog=substitute(system("which python"), '\n', '', 'g')
        let g:python3_host_prog=substitute(system("which python3"), '\n', '', 'g')
    endif
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif

nmap <silent> <leader>m :Denite mapping<CR>
nmap <silent> <F4> :Denite outline<CR>
nmap <silent> <F3> :Semshi toggle<CR>
let g:deoplete#auto_complete_delay = 10
" let g:deoplete#enable_at_startup = 1

let g:deoplete#enable_at_startup = 1

" use tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

let g:jedi#show_call_signatures = "1"

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
"----------------------------------------------
" Plugin: 'w0rp/ale'
"----------------------------------------------
" Gutter Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

let g:ale_linters_explicit = 1
" " Fix Python files with autopep8 and yapf.
let g:ale_python_mypy_options = '--ignore-missing-imports'

let g:ale_fix_on_save=0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
let g:ale_keep_list_window_open = 1
" Set this if you want to.
" Enable integration with " Check Python files with flake8 and pylint.
let b:ale_linters = { 'python': ['flake8', 'mypy' ] }
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = { 'python' : ['black'],
                \    'lua' : ['trimwhitespace', 'remove_trailing_lines'] }
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0

" user environment
let g:ale_virtualenv_dir_names = []

let g:ale_python_auto_pipenv = 1

augroup vim_blacklist_blacklist
autocmd FileType * ((index(s:blacklist, &bt) < 0)?call s:ale_settings() )
augroup END

function! s:ale_settings()
    nmap ]a :ALENextWrap<CR>
    nmap [a :ALEPreviousWrap<CR>
    nmap ]A :ALELast
    nmap [A :ALEFirst
    nmap <F8> <Plug>(ale_fix)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endfunction
"
"----------------------------------------------
" Plugin 'ryanoasis/vim-devicons'
"----------------------------------------------
let g:webdevicons_enable_denite = 1

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
            \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
            \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
            denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
            \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
            \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
\ denite#do_map('toggle_select').'j'
endfunction

"----------------------------------------------
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------
let g:lightline = {
      \ 'active': {
      \   'left': [ [  'mode', 'paste', 'spell' ],
      \             [ 'pyenv', 'pyenv_active' ],
      \             ['gitbranch', 'fugitive' ] ],
      \   'right': [ ['filename', 'lineno', 'percent' ], 
      \              [ 'filetype', 'fileformat', 'readonly' ],
      \              [ 'linter_checking', 'linter_errors',
      \                'linter_warnings', 'linter_ok'  ]
      \            ]
      \ },
      \ 'seperator' : { 'right': '', 'left': '' },
      \ 'subseperator' : { 'right': '', 'left': '' },
      \ 'component_expand' : {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \  'pyenv': 'pyenv#pyenv#get_activated_env',
      \  'gitbranch': 'fugitive#head'
      \ },
      \ 'component': {
      \   'spell': '%{&spell?&spelllang:""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{&filetype=="help"?"":exists("*FugitiveStatusline")?FugitiveStatusline():""}',
      \   'pyenv_active': '%{&filetype!="python"?"":exists("pyenv#pyenv#is_activated")&&pyenv#pyenv#is_activated()?"\uf00c":""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(&filetype!="help"&&exists("*FugitiveStatusline") && ""!=FugitiveStatusline())',
      \   'pyenv_active': '(&filetype!="python"&&exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated())'
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \     'pyenv_active': 'ok'
      \ },
      \ 'component_function': {
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ 'colorscheme' : 'one',
      \ }

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! MyFiletype()
return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "

"----------------------------------------------
" Plugin: bling/vim-go
"----------------------------------------------
"
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"

au FileType go nmap <leader>gt :GoDeclsDir<cr>
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
" Test coverage
au FileType go nmap <F9> :GoCoverageToggle -short<cr>
au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)

" show type in status bar
let g:go_auto_type_info = 1
au FileType go nmap <Leader>d <Plug>(go-def)
" Snake case or camel case
let g:go_addtags_transform = "snakecase"

"----------------------------------------------
" Plugin: christoomey/vim-tmux-navigator
"----------------------------------------------
" Tmux vim integration
let g:tmux_navigator_no_mappings = 1
if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
    " tmux will send xterm-style keys when its xterm-keys option is on
    if &term =~ '^screen'
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    endif

    let g:tmux_navigator_save_on_switch = 1

    " Move between splits with ctrl+h,j,k,l
    nnoremap <silent> <leader><c-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <leader><c-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <leader><c-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <leader><c-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <leader><c-\> :TmuxNavigatePrevious<cr>
endif

if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
endif

"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggle<cr>

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1

" Files to ignore
let NERDTreeIgnore = [
    \ '\~$',
    \ '\.pyc$',
    \ '^\.DS_Store$',
    \ '^node_modules$',
    \ '^.ropeproject$',
    \ '^__pycache__$'
\]

" Close vim if NERDTree is the only opened window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Show hidden files by default.
let NERDTreeShowHidden = 1

" Allow NERDTree to change session root.
let g:NERDTreeChDirMode = 2

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0


" --------------------------------------------
" Colorscheme 
" --------------------------------------------
colorscheme one

set background=dark " for the light version

map <F3> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
let g:one_allow_italics = 1 " I love italic for comments

" Set max line length.
let linelen = 120 
execute "set colorcolumn=".linelen
highlight OverLength ctermbg=red ctermfg=white guibg=#e88388
execute "match OverLength /\%".linelen."v.\+/"

" base 00
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=0 guibg=#353a44
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=7 guibg=#abb2bf

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Set max line length.
" let linelen = 120 
" execute "set colorcolumn=".linelen
" execute "match OverLength /\%".linelen."v.\+/"

" set highlight cursor
"augroup CursorLine
"  au!
"  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
"augroup END
"
" --------------------------------------------
" Plugin: 'numirias/semshi'
" --------------------------------------------
function! SemhiOneHighlights()
hi semshiLocal           ctermfg=209 guifg=#e88388
hi semshiGlobal          ctermfg=214 guifg=#56b6c2
hi semshiImported        ctermfg=214 guifg=#56b6c2 cterm=bold gui=bold
hi semshiParameter       ctermfg=75  guifg=#61AFEF
hi semshiParameterUnused ctermfg=117 guifg=#61AFEF cterm=underline gui=underline
hi semshiFree            ctermfg=218 guifg=#ffafd7
hi semshiBuiltin         ctermfg=207 guifg=#c678dd
hi semshiAttribute       ctermfg=49  guifg=#a7cc8c
hi semshiSelf            ctermfg=249 guifg=#abb2bf
hi semshiUnresolved      ctermfg=226 guifg=#e5c07b cterm=underline gui=underline
hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#

hi semshiErrorSign       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
hi semshiErrorChar       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
endfunction

autocmd FileType python call SemhiOneHighlights()
" 
" if has('nvim')
" 	hi g:terminal_color_0 guifg=#353a44 guibg=#353a44
" 	hi g:terminal_color_8 guifg=#353a44 guibg=#353a44
" 	hi g:terminal_color_1 guifg=#e88388 guibg=#e88388
" 	hi g:terminal_color_9 guifg=#e88388 guibg=#e88388
" 	hi g:terminal_color_2 guifg=#a7cc8c guibg=#a7cc8c
" 	hi g:terminal_color_10 guifg=#a7cc8c guibg=#a7cc8c
" 	hi g:terminal_color_3 guifg=#ebca8d guibg=#ebca8d
" 	hi g:terminal_color_11 guifg=#ebca8d guibg=#ebca8d
" 	hi g:terminal_color_4 guifg=#72bef2 guibg=#72bef2
" 	hi g:terminal_color_12 guifg=#72bef2 guibg=#72bef2
" 	hi g:terminal_color_5 guifg=#d291e4 guibg=#d291e4
" 	hi g:terminal_color_13 guifg=#d291e4 guibg=#d291e4
" 	hi g:terminal_color_6 guifg=#65c2cd guibg=#65c2cd
" 	hi g:terminal_color_14 guifg=#65c2cd guibg=#65c2cd
" 	hi g:terminal_color_7 guifg=#e3e5e9 guibg=#e3e5e9
" 	hi g:terminal_color_15 guifg=#e3e5e9 guibg=#e3e5e9
" endif
" 
" --------------------
" Plugin 'janko/vim-test'
" --------------------
"
autocmd FileType * ((index(s:blacklist, &bt) < 0)?call s:vim_test_keymap())

function! s:vim_test_keymap()
    nmap <silent> t<C-n> :TestNearest<CR>
    nmap <silent> t<C-f> :TestFile<CR>
    nmap <silent> t<C-s> :TestSuite<CR>
    nmap <silent> t<C-l> :TestLast<CR>
    nmap <silent> t<C-g> :TestVisit<CR>
endfunction

let g:test#runner_commands = ['buck']
let test#python#buck#executable = 'buck test'
let test#python#runner = 'buck'
