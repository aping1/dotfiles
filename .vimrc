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
||||||| merged common ancestors

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
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" Fix up arrow not working in search.
set laststatus=2
set number

set tabstop=4
set sw=4
set ai
set expandtab
set hlsearch

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
||||||| merged common ancestors
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'flazz/vim-colorschemes'
"Plugin 'severin-lemaignan/vim-minimap'
Plugin 'tpope/vim-scriptease'
"Plugin 'applescript.vim'
Plugin 'Tagbar'
Plugin 'vim-flake8'
Plugin 'SimpylFold'
" other packages, run ' vim +PluginInstall +qall ' to up date them
Plugin 'lifepillar/vim-solarized8'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
"Plugin 'saltstack/salt-vim'
"Plugin 'scrooloose/syntastic'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/ag.vim'
Plugin 'rizzatti/dash.vim'


Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-obsession'
Plugin 'vim-scripts/vim-misc'
Plugin 'vim-scripts/gitdiff.vim'
Plugin 'vim-scripts/pdbvim'
"Plugin 'solarnz/thrift.vim'


Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Local Shortccuts
Plugin 'file:///home/aping1/.dotfiles/vim/colorscheme'

" uses pygtk
" A simple color picker for VIM, based on GTK color chooser dialog.
" Plugin 'vim-scripts/VIM-Color-Picker'
" A script that lets you insert hex color codes by using OS X's color picker
" Plugin 'vim-scripts/ColorX'

call vundle#end()
filetype plugin indent on     " required

if isdirectory("~/.config/nvim/plugged") 
    call plug#begin("~/.config/nvim/plugged")
||||||| merged common ancestors
" These lines setup the environment to show graphics and colors correctly.
set nocompatible

else
    if empty(glob('~/.vim/autoload/plug.vim'))
        if empty(glob('~/.vim/plugged/plug.vim'))
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    endif 
    call plug#begin('~/.vim/plugged')
||||||| merged common ancestors
" Quickly close in gui mode
if ! has('gui_running')
   set ttimeoutlen=10
   augroup FastEscape
      autocmd!
      au InsertEnter * set timeoutlen=0
      au InsertLeave * set timeoutlen=1000
   augroup END
endif

    Plug 'jez/vim-superman'
    " --- Colorscheme ---
    Plug 'jacoborus/tender.vim'
||||||| merged common ancestors
"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1

    Plug 'vim-scripts/ag.vim'

    Plug 'scrooloose/nerdtree'

    Plug 'tpope/vim-fugitive'
    Plug 'ludovicchabant/vim-lawrencium'

    Plug 'plytophogy/vim-virtualenv'

    Plug 'tmhedberg/SimpylFold'
    Plug 'itchyny/lightline.vim'
    Plug 'ryanoasis/vim-devicons'

    Plug 'altercation/vim-colors-solarized'
    Plug 'tmhedberg/SimpylFold'
    Plug 'itchyny/lightline.vim'
    Plug 'maximbaz/lightline-ale'
||||||| merged common ancestors
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
"
" pymode options
"

    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'roxma/vim-tmux-clipboard'
||||||| merged common ancestors
" OPTION: g:pymode_folding -- bool. Disable python-mode folding for pyfiles.
"call pymode#Default("g:pymode_folding", 0)

    " --- languages
    Plug 'saltstack/salt-vim'
    Plug 'vim-scripts/applescript.vim'
    Plug 'hashivim/vim-terraform'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
||||||| merged common ancestors
" OPTION: g:pymode_syntax -- bool. Enable python-mode syntax for pyfiles.
"call pymode#Default("g:pymode_syntax", 1)

    call plug#end()
||||||| merged common ancestors
" OPTION: g:pymode_indent -- bool. Enable/Disable pymode PEP8 indentation
"call pymode#Default("g:pymode_indent", 1)

||||||| merged common ancestors
" OPTION: g:pymode_utils_whitespaces -- bool. Remove unused whitespaces on save
"call pymode#Default("g:pymode_utils_whitespaces", 1)

||||||| merged common ancestors
" OPTION: g:pymode_options -- bool. To set some python options.
"call pymode#Default("g:pymode_options", 1)

    " Change the Pmenu colors so they're more readable.
    highlight Pmenu ctermbg=cyan ctermfg=white
    highlight PmenuSel ctermbg=black ctermfg=white
||||||| merged common ancestors
" OPTION: g:pymode_updatetime -- int. Set updatetime for async pymode's operation
"call pymode#Default("g:pymode_updatetime", 1000)

    let linelen=80
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    execute "match OverLength /\%".linelen."v.\+/"
||||||| merged common ancestors
" OPTION: g:pymode_lint_ignore -- string. Skip errors and warnings (e.g.  E4,W)
"call pymode#Default("g:pymode_lint_ignore", "E501")

    " set highlight cursor
    "augroup CursorLine
    "  au!
    "  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    "  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
    "  au WinLeave * setlocal nocursorline
    "augroup END

endif

"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1




" Reload .vimrc immediately when edited
autocmd! bufwritepost vimrc source ~/.vimrc
" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white
||||||| merged common ancestors
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
let g:easytags_dynamic_files = 1
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

" colorscheme
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("termguicolors"))
    set termguicolors
    if exists('*plug#begin')
        colorscheme tender
    else
        colorscheme solarized
    endif 
else
    set t_Co=256
    colorscheme solarized
    let g:solarized_termcolors=256
endif

set background=dark

map <F4> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

set guifont=Hack\ Nerd\ Font:h12

set clipboard=unnamed
||||||| merged common ancestors
:map <F2> :colorscheme solarized8_high

" Pythong Template =s
"
" au BufNewFile *.py 0r ~/.vim/python.skel | let IndentStyle = "python"


if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" ------------------------------------------------
"  diff mode for commits
" ------------------------------------------------
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
            \ 'colorscheme' : 'tender',
            \   'separator': { 'left': ' ', 'right': '' },
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
" ----- colorscheme helpers
fun! s:setLightlineColorscheme(name)
    let g:lightline.colorscheme = a:name
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
    " inject center bar blank into pallete (an interesting hack)
    let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    "let s:palette.inactive.middle = s:palette.normal.middle
    let s:palette.tabline.middle = s:palette.normal.middle
endfun

fun! s:lightlineColorschemes(...)
    return join(map(
                \ globpath(&rtp,"autoload/lightline/colorscheme/*.vim",1,1),
                \ "fnamemodify(v:val,':t:r')"),
                \ "\n")
endfun


com! -nargs=1 -complete=custom,s:lightlineColorschemes LightlineColorscheme
            \ call s:setLightlineColorscheme(<q-args>)


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

||||||| merged common ancestors
