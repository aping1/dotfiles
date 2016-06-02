"
"
" ~/.vimrc (remote shell)
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
"set noswapfile
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

" Fix up arrow not working in search.
imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#rc()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'
"call vundle#rc(path)
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'gmarik/vundle'

" other packages, run ' vim +PluginInstall +qall ' to up date them
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'elzr/vim-json'
Plugin 'saltstack/salt-vim'
Plugin 'lepture/vim-jinja'
Plugin 'vim-scripts/snipMate'
Plugin 'vim-scripts/taglist.vim'
Plugin 'benmills/vimux'
Plugin 'mileszs/ack.vim'
Plugin 'protocool/AckMate'

Plugin 'christoomy/vim-tmux-navigator'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-obsession'
Plugin 'vim-scripts/vim-misc'
Plugin 'vim-scripts/easytags.vim'
Plugin 'vim-scripts/gitdiff.vim'
Plugin 'vim-scripts/pdbvim'
Plugin 'vim-scripts/vim-json-bundle'
Plugin 'vim-scripts/grep.vim'
Plugin 'vim-scripts/Tagbar'
Plugin 'vim-scripts/surrond.vim'
Plugin 'szw/vim-tags.git'

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

" Tagsgenerate from scw/vim-tags
set exrc
set secure

"  set t_Co=256
set t_Co=16
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

:au BufNewFile,BufRead *.jinja set filetype=jinja

:au BufNewFile,BufRead *.input set filetype=json

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" pyflakes
let g:khuno_ignore="E501"

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
set tags=./tags,tags;$HOME
let g:easytags_dynamic_files = 1

" Tell VIM to use ack instead of grep.
set grepprg=grep

" Make underscores part of words.
"set iskeyword-=_
set iskeyword+=-

" When shifting always round to the correct indentation.
set shiftround

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.

" Run lint on these file types.
"au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"
"au FileType json exe ":silent 1, $!jq . - 2> /dev/null"

let g:airline_powerline_fonts = 1
set term=xterm-256color
set background=dark
try
  " Solarized options
  syntax enable
  let g:solarized_term = 1
  let g:solarized_visibility = "high"
  let g:solarized_contrast   = "high"
  let g:solarized_termtrans = 1
  let g:solarized_termcolors=16
  colorscheme solarized


catch
endtry

" AirlineTheme dark
set mouse+=a
if &term =~ '^screen' || &term =~ '^xterm'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
set foldcolumn=2

"function! UpdateTags()
"  let f = expand("%:p")
"  let cwd = getcwd()
"  let tagfilename = cwd . "/tags"
"  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
"  call DelTagOfFile(f)
"  let resp = system(cmd)
"endfunction

autocmd BufWritePost * exe ":UpdateTags"
set re=0


au BufNewFile *.py 0r ~/.vim/python.skel | let IndentStyle = "python"
