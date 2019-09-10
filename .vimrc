"
"
" ~/.vimrc (local shell)
"
filetype off                  " required

set ruler
set ignorecase
set smartcase

set shell=/bin/bash
set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set noswapfile
set incsearch
set title
set showmode
set wildmenu
set history=1000

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
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" Fix up arrow not working in search.

set laststatus=2
set number

set ts=4
set sw=4
set ai
set expandtab
set hlsearch

" set the runtime path to include Vundle and initialize
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-scriptease'
Plug 'majutsushi/tagbar'
Plug 'tmhedberg/SimpylFold'
Plug 'lifepillar/vim-solarized8'

" Git 
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'airblade/vim-gitgutter'

"Plug 'scrooloose/syntastic'
"Plug 'Valloric/YouCompleteMe'
"
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/ag.vim'

Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline.git'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'

" --- languages
" Plug 'saltstack/salt-vim'
" Plug 'applescript.vim'
Plug 'hashivim/vim-terraform'

" Local Shortccuts
" Plug 'file:///home/aping1/.dotfiles/vim/colorscheme'

" uses pygtk
" A simple color picker for VIM, based on GTK color chooser dialog.
" Plug 'vim-scripts/VIM-Color-Picker'
" A script that lets you insert hex color codes by using OS X's color picker
" Plug 'vim-scripts/ColorX'

call plug#end()
filetype plugin indent on     " required

" These lines setup the environment to show graphics and colors correctly.
set nocompatible

" Quickly close in gui mode
if ! has('gui_running')
   set ttimeoutlen=10
   augroup FastEscape
      autocmd!
      au InsertEnter * set timeoutlen=0
      au InsertLeave * set timeoutlen=1000
   augroup END
endif

" memory leak problem
if version >= 702
    autocmd BufWinLeave * call clearmatches()
endif

:au BufNewFile,BufRead *.jinja set filetype=jinja

:au BufNewFile,BufRead *.input set filetype=json

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Reload .vimrc immediately when edited
autocmd! bufwritepost vimrc source ~/.vimrc

" Set max line length.
let linelen = 80
execute "set colorcolumn=".linelen
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
execute "match OverLength /\%".linelen."v.\+/"

" set highlight cursor
"augroup CursorLine
"  au!
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
"augroup END


" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME

" Make underscores part of words.
autocmd BufNewFile,BufWinEnter *.[h|c] set iskeyword+=_
"autocmd BufNewFile,BufWinEnter *.[h|c] set iskeyword="a-z,A-Z,48-57,_,.,-,>"
"set iskeyword+=-

" When shifting always round to the correct indentation.
set shiftround

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.
" Show < or > when characters are not displayed on the left or right.
":set list listchars=precedes:<,extends:>
" Same, but also show tabs and trailing spaces.
":set list listchars=tab:>-,trail:.,precedes:<,extends:>
" Show invisible characters as dots
":set listchars=tab:··,trail:·

" Run lint on these file types.
"au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"
"au FileType json exe ":silent 1, $!jq . - 2> /dev/null"

set mouse+=a
if &term =~ '^screen' || &term =~ '^xterm'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" colorscheme
colorscheme solarized8_flat
set background=dark

set guifont=Hack\ Nerd\ Font:h12

set clipboard=unnamed

" Pythong Template =s
"
" au BufNewFile *.py 0r ~/.vim/python.skel | let IndentStyle = "python"
au BufNewFile COMMIT_EDITING let syntax = diff
" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m
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
autocmd FileType * call s:ale_settings()
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

"----------------------------------------------
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------

let g:lightline = {
      \ 'active': {
      \   'left': [ [  'mode', 'paste', 'spell' ],
      \             [ 'pyenv', 'pyenv_active' ],
      \             [ 'fugitive' ] ],
      \   'right': [ ['filename', 'lineno', 'percent' ], 
      \              [ 'filetype', 'fileformat', 'readonly' ],
      \              [ 'linter_checking', 'linter_errors',
      \                'linter_warnings', 'linter_ok'  ]
      \            ]
      \ },
      \ 'component_expand' : {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \  'gitbranch': 'fugitive#head'
      \ },
      \ 'component': {
      \   'spell': '%{&spell?&spelllang:""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{&filetype=="help"?"":exists("*FugitiveStatusline")?FugitiveStatusline():""}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(&filetype!="help"&&exists("*FugitiveStatusline") && ""!=FugitiveStatusline())',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ 'component_function': {
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ 'colorscheme' : 'solarized',
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '', 'right': '' },
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

" --------------------
" Plugin 'janko/vim-test'
" --------------------
"
autocmd FileType * call s:vim_test_keymap()


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


