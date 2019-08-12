"
"G
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
set history=10000

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

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" -----
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
endif
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

Plug 'gyim/vim-boxdraw'
Plug 'mg979/vim-visual-multi'


" --- Colorscheme ---
Plug 'flazz/vim-colorschemes'
Plug 'iCyMind/NeoSolarized'
Plug 'jacoborus/tender.vim'
Plug 'rakr/vim-one'


Plug 'Shougo/denite.nvim'
Plug 'dunstontc/denite-mapping'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'numkil/ag.nvim'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'


Plug 'SidOfc/mkdx'
Plug 'itspriddle/vim-marked'
Plug 'tpope/vim-fugitive'
" mecurial client
Plug 'ludovicchabant/vim-lawrencium'

Plug 'plytophogy/vim-virtualenv'
Plug 'lambdalisue/vim-pyenv'
Plug 'w0rp/ale'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'aping1/deoplete-zsh', { 'branch': 'fix_completion' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

Plug 'Vigemus/impromptu.nvim'
Plug 'Vigemus/iron.nvim'
Plug 'bfredl/nvim-ipy'
Plug 'janko/vim-test'

Plug 'Shougo/denite.nvim', { 'branch': 'master' }
Plug 'dunstontc/denite-mapping'

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


Plug 'aping1/deoplete-zsh', {'branch': 'fix-completion'}
Plug 'roxma/vim-tmux-clipboard'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug '~/.doftiles/vim/projects'

" Session 
"Plug 'tpope/vim-obsession'
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

filetype plugin indent on     " required

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

" newomake automagic check

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
" disable autocompletion, cause we use deoplete for completion
" disable autocompletion, cause we use deoplete for completion
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
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
" use tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

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
let b:ale_linters = { 'python' : ['flake8', 'pyre'] }
let b:ale_linters = { 'python' : ['flake8', 'pyre'], 
            \       'sh' : ['shellcheck'],
            \       'terraform' : ['tflint'] }
" " Fix Python files with autopep8 and yapf.
let g:ale_fixers = { 'python' : ['black' ] }
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
            \       'lua' : ['trimwhitespace', 'remove_trailing_lines'] }

" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0

" user environment
let g:ale_virtualenv_dir_names = []

let g:ale_python_auto_pipenv =1


:nmap ]a :ALENextWrap<CR>
:nmap [a :ALEPreviousWrap<CR>
:nmap ]A :ALELast
:nmap [A :ALEFirst
nmap <F8> <Plug>(ale_fix)
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
				\ denite#do_map('do_action', 'preview')
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
" :au BufNewFile,BufRead AirlineTheme luna
" let g:airline_theme='solarized_flood' " <theme> is a valid theme name
" let g:airline_solarized_bg='dark'
" let g:airline_theme='one' " <theme> is a valid theme name

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#ale#enabled = 1

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
" tmux will send xterm-style keys when its xterm-keys option is on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Tmux vim integration
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 1

" Move between splits with ctrl+h,j,k,l
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

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
colorscheme one

augroup IndentGuests
" base 00
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=8 guibg=#002b36
" base 01
"autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=8 guibg=#586e75
" base 02
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=0 guibg=#073642 

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Set max line length.
"let linelen = 120 
" execute "set colorcolumn=".linelen
"execute "match OverLength /\%".linelen."v.\+/"

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
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let g:test#runner_commands = ['buck']
let test#python#buck#executable = 'buck test'
let test#python#runner = 'buck'


function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr 'no output'
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message

  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . 'cfirst'
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
