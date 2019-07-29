"
"
" ~/.vimrc (local shell)
"

set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on     " required

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

" Reload .vimrc immediately when edited
autocmd! bufwritepost vimrc source ~/.vimrc

set mouse+=a
if &term =~ '^screen' || &term =~ '^xterm'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME

set ruler

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

" When shifting always round to the correct indentation.
set shiftround

set smarttab
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
set expandtab
set hlsearch

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


if ! empty(glob('~/.vim/autoload/plug.vim'))
    call plug#begin('~/.vim/plugged')

    Plug 'jez/vim-superman'
    " --- Colorscheme ---
    Plug 'jacoborus/tender.vim'

    Plug 'Shougo/denite.nvim'
    Plug 'dunstontc/denite-mapping'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'numkil/ag.nvim'

    Plug 'scrooloose/nerdtree'

    Plug 'tpope/vim-fugitive'
    Plug 'ludovicchabant/vim-lawrencium'

    Plug 'plytophogy/vim-virtualenv'
    Plug 'lambdalisue/vim-pyenv'

    Plug 'tmhedberg/SimpylFold'
    Plug 'itchyny/lightline.vim'
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

    colorscheme tender

    " Change the Pmenu colors so they're more readable.
    highlight Pmenu ctermbg=cyan ctermfg=white
    highlight PmenuSel ctermbg=black ctermfg=white

    let linelen=80
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    execute "match OverLength /\%".linelen."v.\+/"

    " set highlight cursor
    "augroup CursorLine
    "  au!
    "  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    "  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
    "  au WinLeave * setlocal nocursorline
    "augroup END

endif
" ------------------------------------------------
"  cursor and line len settings
" ------------------------------------------------
"

" Make underscores part of words for c files
autocmd BufNewFile,BufWinEnter *.[h|c] set iskeyword+=_
"autocmd BufNewFile,BufWinEnter *.[h|c] set iskeyword="a-z,A-Z,48-57,_,.,-,>"


" ------------------------------------------------
"  list settings
" ------------------------------------------------
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.
" Show < or > when characters are not displayed on the left or right.
":set list listchars=precedes:<,extends:>
" Same, but also show tabs and trailing spaces.
":set list listchars=tab:>-,trail:.,precedes:<,extends:>
" Show invisible characters as dots
":set listchars=tab:··,trail:·

" ------------------------------------------------
" filetype settings
" ------------------------------------------------
"
:au BufNewFile,BufRead *.jinja set filetype=jinja

" Run simple lint on structured files
au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"
au FileType json exe ":silent 1, $!jq . - 2> /dev/null"

imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" ------------------------------------------------
"  diff mode for commits
" ------------------------------------------------
au BufNewFile COMMIT_EDITING let syntax = diff
" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m
