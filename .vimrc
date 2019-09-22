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

if isdirectory("~/.config/nvim/plugged") 
    call plug#begin("~/.config/nvim/plugged")

else
    call plug#begin('~/.vim/plugged')
endif 

" --- Colorscheme(s) ---
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
" Git 
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'airblade/vim-gitgutter'

"Plug 'scrooloose/syntastic'
"Plug 'Valloric/YouCompleteMe'
"
Plug 'tpope/vim-scriptease'
Plug 'majutsushi/tagbar'
Plug 'tmhedberg/SimpylFold'
Plug 'lifepillar/vim-solarized8'

" Vim exploration Modifications
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'vim-scripts/ag.vim'

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mg979/vim-visual-multi'

" Writing
Plug 'SidOfc/mkdx'
Plug 'gyim/vim-boxdraw'

    Plug 'plytophogy/vim-virtualenv'
    Plug 'lambdalisue/vim-pyenv'

Plug 'w0rp/ale'
Plug 'Shougo/echodoc.vim'

Plug 'tmhedberg/SimpylFold'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

Plug 'jez/vim-superman'

" --- languages
Plug 'saltstack/salt-vim'
Plug 'vim-scripts/applescript.vim'
Plug 'hashivim/vim-terraform'

" Local Shortccuts
" Plug 'file:///home/aping1/.dotfiles/vim/colorscheme'

    " Change the Pmenu colors so they're more readable.
    highlight Pmenu ctermbg=cyan ctermfg=white
    highlight PmenuSel ctermbg=black ctermfg=white

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
