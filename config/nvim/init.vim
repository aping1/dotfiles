" FileType js UltiSnipsAddFiletypes javascript-jasmine time to wait for new mapping seq
" ttimeoutlen is used for key code delays
" Credit: https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" also cjeckout  /Users/aping1/.dotfiles/config/nvim/autoload/mappings.vim
set timeoutlen=600 ttimeoutlen=0


set ruler
set ignorecase
set smartcase

set shell=/bin/bash
set encoding=utf8
" required for iterm 
"set ambiwidth=double
set ambiwidth=
set fileformats=unix,dos,mac
set nobackup
set noswapfile
set incsearch
set title
set showmode
set wildmenu
set history=10000

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

set laststatus=2
set number

" --------------------
"  TABs 
" --------------------
" To control the number of space characters that will be inserted when the tab key is pressed,
set tabstop=4
" `retab` command To change all the existing tab characters to match the current tab settings
"       :h retab
" shiftwidth: change the number of space characters inserted for indentation
set shiftwidth=4
" Expand tab to spaces whenever the tab key is pressed
set expandtab
"Highlight Search results
" `noh`: Command to cancel current highlight
"       :h noh[higlight]
set hlsearch

set number relativenumber

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    autocmd BufReadPost * set norelativenumber
augroup END

let g:linelen=120
autocmd Syntax * let g:focusmode_width = getbufvar("b", "linelen", g:linelen)

set listchars+=nbsp:
set listchars+=precedes:﬌
set listchars+=space:

set fillchars+=fold:
set fillchars+=stlnc:─
set fillchars+=vert:
set fillchars+=eob:@
" :h 'fillchars'
"	  stl:c		' ' or '^'	statusline of the current window
"	  stlnc:c	' ' or '='	statusline of the non-current windows
"	  vert:c	'│' or '|'	vertical separators |:vsplit|
"	  fold:c	'·' or '-'	filling 'foldtext'
"	  diff:c	''		deleted lines of the 'diff' option
"	  msgsep:c	' '		message separator 'display'
"	  eob:c		'~'		empty lines at the end of a buffer

set clipboard=unnamedplus


if has("autoread")
    " Reload .vimrc immediately when edited
    set autoread
else
augroup AUTOUPDATE
    autocmd! 
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END
endif
" Reload .vimrc immediately when edited

if &compatible
    set nocompatible
endif

autocmd VimResized * wincmd =

" You will have bad experience for diagnostic messages when it's default 4000.
" Write diag to disk every 2.5 seconds
set updatetime=2500

set background=dark

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Contains dein snippet
let g:dein_file=(expand('<sfile>:p:h') . '/autoload/00-dein.vim')

if filereadable(g:dein_file) || filereadable(glob(g:dein_file))
     exe 'source ' . glob(g:dein_file)
else
    echoerr 'Failed to source ' . g:dein_file
    silent! colorscheme default
    finish
endif

if has('gui_running')
    silent! colorscheme one
elseif (has('termguicolors'))
    set termguicolors
    silent! colorscheme one  
    if exists(':LightlineColorschem')
    silent! LightlineColorscheme one
    endif 
elseif &term =~? '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
    set t_Co=256
    silent! colorscheme solarized
    silent! LightlineColorscheme solarized
    let g:solarized_termcolors=256
else
    colorscheme default
    set t_Co=16
endif

" { :set sw=2 ts=2 et }
