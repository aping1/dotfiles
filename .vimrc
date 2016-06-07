set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'gmarik/vundle'

" other packages, run ' vim +PluginInstall +qall ' to up date them
Plugin 'airblade/vim-gitgutter'
Plugin 'elzr/vim-json'
Plugin 'saltstack/salt-vim'
Plugin 'lepture/vim-jinja'
Plugin 'benmills/vimux'
Plugin 'mileszs/ack.vim'
Plugin 'protocool/AckMate'

Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-obsession'
Plugin 'vim-scripts/vim-misc'
Plugin 'vim-scripts/easytags.vim'
Plugin 'vim-scripts/gitdiff.vim'
Plugin 'vim-scripts/pdbvim'

Plugin 'altercation/vim-colors-solarized'  
Plugin 'vim-scripts/taglist-plus'
Plugin 'vim-scripts/Trinity'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/vim-json-bundle' " Pathogen friendly file type plugin bundle for json files

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'

"Plugin 'bling/vim-airline'

call vundle#end()
filetype plugin indent on     " required
"" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install (update) bundles
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

set laststatus=2
set number

set ts=4
set sw=4
set ai
set expandtab
set hlsearch

set t_Co=256
"set t_Co=16
" SaltStack - Force using the Django template syntax file
" let g:sls_use_jinja_syntax = 0

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight ExtraWhitespace ctermbg=red guibg=red

" The following alternative may be less obtrusive.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen

" Try the following if your GUI uses a dark background.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Using before the first colorscheme command will ensure that the highlight group gets created and is not cleared by future colorscheme commands
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Show trailing whitespace:
":match ExtraWhitespace /\s\+$/

" Show trailing whitespace and spaces before a tab:
":match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
":match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
":match ExtraWhitespace /^\t*\zs \+/

" Switch off :match highlighting.
":match

" The following pattern will match trailing whitespace, except when typing at the end of a line.
:match ExtraWhitespace /\s\+\%#\@<!$/

" If you use this alternate pattern, you may want to consider using the following autocmd to let the highlighting show up as soon as you leave insert mode after entering trailing whitespace:
":autocmd InsertLeave * redraw!
:au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match ExtraWhitespace /\s\+$/

" Supported languages are: ada, c, chill, csc, forth, groovy, icon, java, lpc, mel, nqc, nroff, ora, pascal, plm, plsql, python and ruby. The c settings also apply to cpp.
"let c_space_errors = 0
"let ada_space_errors = 1
"let chill_space_errors = 1
"let csc_space_errors = 1
"let forth_space_errors = 1
"let groovy_space_errors = 1
"let icon_space_errors = 1
"let java_space_errors = 1
"let lpc_space_errors = 1
"let nroff_space_errors = 1
"let ora_space_errors = 1
"let pascal_space_errors = 1
let plsql_space_errors = 1
"let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1

" For C, if you don't want to see trailing space errors at end-of-line set:
"let c_no_trail_space_error = 1

" If you only use spaces to indent, and don't want to see space errors in front of tabs:
"let c_no_tab_space_error = 1

" Show long lines
" Show < or > when characters are not displayed on the left or right.
":set list listchars=precedes:<,extends:>
" Same, but also show tabs and trailing spaces.
":set list listchars=tab:>-,trail:.,precedes:<,extends:>
" Show invisible characters as dots
":set list
":set listchars=tab:··,trail:·

" memory leak problem
if version >= 702
    autocmd BufWinLeave * call clearmatches()
endif
 
" Always display the statusline in all windows
set laststatus=2 
" set font
set guifont=Sauce\ Code\ for\ Powerline:h14 

" Hide the default mode text (e.g. -- INSERT -- below the statusline)
" set noshowmode 

" Show line numbers
set number        
" Use syntax highlighting
syntax enable     

" fix backspace to work like you would expect
set backspace=indent,eol,start

" Color Scheme
colorscheme solarized_high

" Set max line length.
"let linelen = 100
"execute "set colorcolumn=".linelen
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"execute "match OverLength /\%".linelen."v.\+/"

" Tell VIM which tags file to use.
set tags=./tags
let g:easytags_dynamic_files = 1

" Tell VIM to use ack instead of grep.
set grepprg=grep

" Make underscores part of words.
"set iskeyword-=_

" When shifting always round to the correct indentation.
set shiftround

" Run lint on these file types.
"au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"
"au FileType json exe ":silent 1, $!jq . - 2> /dev/null"

let g:airline_powerline_fonts = 1
set term=xterm-256color
set background=dark
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_termcolors=256

" Setup airline
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:minBufExplForceSyntaxEnable = 1
