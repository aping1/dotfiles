"
"
" ~/.vimrc (local shell)
"

set nocompatible              " be iMproved, required
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
" Fix up arrow not working in search.

set laststatus=2
set number

set ts=4
set sw=4
set ai
set expandtab
set hlsearch

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'applescript.vim'
Plugin 'Tagbar'
" other packages, run ' vim +PluginInstall +qall ' to up date them
Plugin 'lifepillar/vim-solarized8'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/ag.vim'
Plugin 'rizzatti/dash.vim'


Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-obsession'
Plugin 'vim-scripts/vim-misc'
Plugin 'vim-scripts/gitdiff.vim'
Plugin 'vim-scripts/pdbvim'

Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Local Shortccuts
Plugin 'file://~/bundle/allieshortcuts'|

" uses pygtk
" Plugin 'vim-scripts/VIM-Color-Picker' " A simple color picker for VIM, based on GTK color chooser dialog.
Plugin 'vim-scripts/ColorX' " A script that lets you insert hex color codes by using OS X's color picker

call vundle#end()
filetype plugin indent on     " required

" These lines setup the environment to show graphics and colors correctly.
set nocompatible
set t_Co=256
 
" Quickly close in gui mode
if ! has('gui_running') 
   set ttimeoutlen=10
   augroup FastEscape
      autocmd!
      au InsertEnter * set timeoutlen=0
      au InsertLeave * set timeoutlen=1000
   augroup END
endif


""""""""""""""""""""""""""""
"""" Format ExtraWhitespace
"""""""""""""""""""""""""""
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight ExtraWhitespace ctermbg=red guibg=red
" Colorize listchars to be black
" Using before the first colorscheme command will ensure that the highlight group gets created and is not cleared by future colorscheme commands
:autocmd ColorScheme * highlight SpecialKey ctermfg=232
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd ColorScheme * highlight SpecialKey ctermfg=8 ctermbg=0

highlight ColorColumn ctermbg=lightblue
call matchadd('ColorColumn', '\%81v', 100)

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/
" Show tabs that are not at the start of a line:
":match ExtraWhitespace /[^\t]\zs\t\+/
" Show spaces used for indenting (so you use only tabs for indenting).
":match ExtraWhitespace /^\t*\zs \+/
" The following pattern will match trailing whitespace, except when typing at the end of a line.
:match ExtraWhitespace /\s\+\%#\@<!$/
" Switch off :match highlighting.
":match

" If you use this alternate pattern, you may want to consider using the following autocmd to let the highlighting show up as soon as you leave insert mode after entering trailing whitespace:
:autocmd InsertLeave * redraw!
:au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match ExtraWhitespace /\s\+$/

"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1


" memory leak problem
if version >= 702
    autocmd BufWinLeave * call clearmatches()
endif

:au BufNewFile,BufRead *.jinja set filetype=jinja

:au BufNewFile,BufRead *.input set filetype=json

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" pyflakes
let g:khuno_ignore="E501"

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
"
" pymode options
"

" OPTION: g:pymode_folding -- bool. Disable python-mode folding for pyfiles.
"call pymode#Default("g:pymode_folding", 0)

" OPTION: g:pymode_syntax -- bool. Enable python-mode syntax for pyfiles.
"call pymode#Default("g:pymode_syntax", 1)

" OPTION: g:pymode_indent -- bool. Enable/Disable pymode PEP8 indentation
"call pymode#Default("g:pymode_indent", 1)

" OPTION: g:pymode_utils_whitespaces -- bool. Remove unused whitespaces on save
"call pymode#Default("g:pymode_utils_whitespaces", 1)

" OPTION: g:pymode_options -- bool. To set some python options.
"call pymode#Default("g:pymode_options", 1)

" OPTION: g:pymode_updatetime -- int. Set updatetime for async pymode's operation
"call pymode#Default("g:pymode_updatetime", 1000)

" OPTION: g:pymode_lint_ignore -- string. Skip errors and warnings (e.g.  E4,W)
"call pymode#Default("g:pymode_lint_ignore", "E501")

" Reload .vimrc immediately when edited
autocmd! bufwritepost vimrc source ~/.vimrc

" Set max line length.
"let linelen = 100
"execute "set colorcolumn=".linelen
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"execute "match OverLength /\%".linelen."v.\+/"

" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME
let g:easytags_dynamic_files = 1

" Make underscores part of words.
"set iskeyword-=_
set iskeyword+=-

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

" 
try
  if has('gui_running')
    set background=light
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
    let base17colorspace=256        " Access colors present in 256 colorspace
    colorscheme macvim
  else
    set background=dark
    colorscheme solarized8_high
    " FIXME: the following fixes some out of order colorscheme load
    :autocmd BufWinEnter * colorscheme solarized8_high
    :autocmd BufWinEnter * set clipboard=unnamed
  endif
  " Configure UI {
  set term=xterm-256color
  " set term=screen-256color
  set t_Co=256
  colorscheme solarized8_high
  "set nofoldenable                " disable code folding
  syntax enable
" }
"  https://github.com/lifepillar/vim-solarized8
  let g:solarized_term = 1
  let g:solarized_visibility = "high"
  let g:solarized_contrast   = "high"
  let g:solarized_termtrans = 1
  let g:solarized_termcolors=16
  let g:solarized_statusline=1
catch
endtry
" Airline
try
  let g:airline#extensions#tabline#enabled = 1
  if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_powerline_fonts = 1
  let g:airline_symbols.space = "\ua0"
  let g:airline_powerline_fonts = 1
  let g:minBufExplForceSyntaxEnable = 1
  let g:airline_theme='solarized'
catch
endtry

set mouse+=a
if &term =~ '^screen' || &term =~ '^xterm'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

:map <F2> :colorscheme solarized8_high

" Pythong Template =s
"
" au BufNewFile *.py 0r ~/.vim/python.skel | let IndentStyle = "python"
au BufNewFile COMMIT_EDITING let syntax = diff
" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m
