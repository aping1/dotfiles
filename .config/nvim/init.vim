"
"
" ~/.vimrc (local shell)
"

set ruler
set ignorecase
set smartcase

set shell=/usr/local/bin/zsh
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
set termguicolors

" set the runtime path to include Vundle and initialize
"
" set rtp+=~/.vim/bundle/Vundle.vim
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

call plug#begin()
Plug 'flazz/vim-colorschemes'

Plug 'iCyMind/NeoSolarized'

Plug 'bfredl/nvim-ipy'

Plug 'plytophogy/vim-virtualenv'
Plug 'lambdalisue/vim-pyenv'
Plug 'zchee/deoplete-jedi'
Plug 'itspriddle/vim-marked'
let g:deoplete#enable_at_startup = 1
" use tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" disable autocompletion, cause we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
" <leader>n: show the usage of a name in current file
" <leader>r: rename a name
Plug 'davidhalter/jedi-vim'
 
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" let g:airline_theme='<theme>' " <theme> is a valid theme name
"
let g:airline_solarized_bg='dark'

" let g:airline_theme='<theme>' " <theme> is a valid theme name

" Auto format
Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'
Plug 'tmhedberg/SimpylFold'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'Vigemus/iron.nvim'

" Indent lines
Plug 'nathanaelkane/vim-indent-guides'

Plug 'junegunn/fzf.vim'
Plug 'numkil/ag.nvim'

" Git gutter
Plug 'mhinz/vim-signify'


"Plugin 'tpope/vim-obsession'
"Plugin 'vim-scripts/vim-misc'
"Plugin 'vim-scripts/gitdiff.vim'
"Plugin 'vim-scripts/pdbvim'
"Plugin 'solarnz/thrift.vim'

" Local Shortccuts
" uses pygtk
" A simple color picker for VIM, based on GTK color chooser dialog.
" Plugin 'vim-scripts/VIM-Color-Picker'
" Plugin 'vim-scripts/ColorX'

call plug#end()
filetype plugin indent on     " required

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 4
let g:indent_guides_start_level = 1

" base 00
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=8 guibg=#002b36
" base 01
"autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=8 guibg=#586e75
" base 02
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=0 guibg=#073642 


colorscheme NeoSolarized
"
" newomake automagic check
call neomake#configure#automake('nrwi', 500)

" These lines setup the environment to show graphics and colors correctly.
set nocompatible

"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1

:au BufNewFile,BufRead AirlineTheme luna
:au BufNewFile,BufRead *.jinja set filetype=jinja

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Reload .vimrc immediately when edited
autocmd! bufwritepost .vim,.vimrc source ~/.config/nvim/init.vim

" Set max line length.
let linelen = 120 
execute "set colorcolumn=".linelen
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
execute "match OverLength /\%".linelen."v.\+/"

" set highlight cursor
"augroup CursorLine
"  au!
"  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
"augroup END


" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME
let g:easytags_dynamic_files = 1


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

if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n1 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif
luafile $HOME/.config/nvim/iron.plugin.lua

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

