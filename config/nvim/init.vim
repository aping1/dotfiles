"
" ~/confing/nvim/init.vim
"


set ruler
set ignorecase
set smartcase

set shell=/bin/bash
set encoding=utf8
" required for iterm 
set ambiwidth=double
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

set tabstop=4
set shiftwidth=4
set hlsearch

set number relativenumber

augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
autocmd BufReadPost * set norelativenumber
augroup END

" -----
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has('nvim'))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
endif

set clipboard=unnamedplus

if exists('$VIRTUAL_ENV')
    let g:python_host_prog=substitute(system('which -a python3 | head -n2 | tail -n1'), '\n', '', 'g')
    let g:python3_host_prog=g:python_host_prog
else
    let g:python_host_prog=substitute(system('command -v python3 || command -v python'), '\n', '', 'g')
    let g:python3_host_prog=g:python_host_prog
endif


let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
let runtimepath=&runtimepath . ',' . substitute(expand('%:p'), autoload_plug_path, '', 'g')
if empty(glob(autoload_plug_path))
  silent ! exec '!curl -fLo ' . autoload_plug_path . 
                \ ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  source &autoload_plug_path
  augroup plug_auto_update
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
else
    exec 'set runtimepath=' . autoload_plug_path . ',' . &runtimepath
endif

unlet autoload_plug_path
" Reload .vimrc immediately when edited
augroup AUTOUPDATE
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
augroup END


call plug#begin('~/.config/nvim/plugged')

" --- Sesnible defaults ---
Plug  'tpope/vim-sensible'

" --- Colorscheme ---
Plug 'flazz/vim-colorschemes'
Plug 'iCyMind/NeoSolarized'
Plug 'jacoborus/tender.vim'
Plug 'rakr/vim-one'

" === Indent lines ===
Plug 'nathanaelkane/vim-indent-guides'
" Git gutter
Plug 'mhinz/vim-signify'
" Highlight colors
Plug 'ap/vim-css-color'
" Auto color hex
Plug 'lilydjwg/Colorizer'

" Hide sum and such as unicode 
Plug 'ryanoasis/vim-devicons'
Plug 'chrisbra/unicode.vim'
" Use math symbols instead of keywords 
"Plug 'ehamberg/vim-cute-python'
Plug 'mhinz/vim-startify'

" Vim exploration Modifications
Plug 'Shougo/denite.nvim'
Plug 'dunstontc/denite-mapping'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'numkil/ag.nvim'

Plug 'leshill/vim-json'

" Projects
Plug 'amiorin/vim-project'
Plug 'tpope/vim-projectionist'

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'scrooloose/nerdcommenter'
Plug 'mg979/vim-visual-multi'

Plug 'SidOfc/mkdx'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-markdown'
Plug 'itspriddle/vim-marked'
Plug 'gyim/vim-boxdraw'

" Version Control
Plug 'tpope/vim-fugitive'
" == mecurial client ==
Plug 'ludovicchabant/vim-lawrencium'
Plug 'majutsushi/tagbar'

" Linting, syntax, autocomplete, semantic highlighting Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'w0rp/ale'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'aping1/deoplete-zsh', { 'branch': 'develop' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Tools for repl
Plug 'Vigemus/impromptu.nvim'
Plug 'Vigemus/iron.nvim'

" Python 
Plug 'plytophogy/vim-virtualenv'
Plug 'lambdalisue/vim-pyenv'
Plug 'bfredl/nvim-ipy'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/context_filetype.vim'
Plug 'janko/vim-test'

" for ZSH Autocomplete
Plug 'mtikekar/nvim-send-to-term'

" Simply Fold 
Plug 'tmhedberg/SimpylFold'

" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

Plug 'jez/vim-superman'

Plug 'ekalinin/Dockerfile.vim'
Plug 'kevinhui/vim-docker-tools'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'towolf/vim-helm'

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

" --- management
Plug 'kevinhui/vim-docker-tools'

" --- languages
Plug 'vim-scripts/applescript.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'towolf/vim-helm'
Plug 'saltstack/salt-vim'
Plug 'hashivim/vim-terraform'

call plug#end()
filetype plugin indent on     " required

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
" Pallet One Colorscheme
    "hi one_terminal_color_fg0 guifg=#353a44
    "hi one_terminal_color_fg1 ctermfg=209 guifg=#e88388
    "hi one_terminal_color_fg2 ctermfg=49 guifg=#a7cc8c 
    "hi one_terminal_color_fg3 ctermfg=226 guifg=#ebca8d
    "hi one_terminal_color_fg4 ctermfg=117 guifg=#72bef2
    "hi one_terminal_color_fg5 ctermfg=207 guifg=#d291e4
    "hi one_terminal_color_fg6 ctermfg=214 guifg=#65c2cd
    "hi one_terminal_color_fg7 ctermfg=231 guifg=#e3e5e9
    "hi one_terminal_color_fg8 ctermfg=231 guifg=#353a44
    "hi one_terminal_color_fg9 ctermfg=249 guifg=#abb2bf

    "hi one_terminal_color_bg9 ctermfg=209 guibg=#e88388
    "hi one_terminal_color_bg10 guibg=#a7cc8c
    "hi one_terminal_color_bg11 ctermfg=226 guibg=#ebca8d
    "hi one_terminal_color_bg12 ctermfg=117 guibg=#72bef2
    "hi one_terminal_color_bg13 ctermfg=207 guibg=#d291e4
    "hi one_terminal_color_bg14 ctermbg=214 guibg=#65c2cd
    "hi one_terminal_color_bg15 guibg=#e3e5e9

if (has('gui_running'))
    silent! colorscheme one
elseif (has('termguicolors'))
    set termguicolors
    silent! colorscheme one  
    silent! LightlineColorScheme one
elseif &term =~? '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
    set t_Co=256
    silent! colorscheme solarized
    silent! LightlineColorScheme solarized
    let g:solarized_termcolors=256
else
    colorscheme default
    set t_Co=16
endif

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

set background=dark

function! s:normalToggleColor()
    :let &background = ( &background ==? 'dark'? 'light' : 'dark' ) 
endfunction

com! -nargs=0 ToggleColor
    \ call s:normalToggleColor()

map <F3> :ToggleColor<CR>

" Set max line length.
let linelen = 120
execute "set colorcolumn=".linelen
highlight OverLength ctermbg=red ctermfg=white ctermfg=231 guifg=#e88388
execute 'match OverLength /\%'.linelen.'v.\+/'

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

"----------------------------------------------
" Plugin: 'nathanaelkane/vim-indent-guides'
"----------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 2
let g:indent_guides_start_level = 2

augroup IndentGuide
" base 00
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd ctermbg=6 guibg=#353a44
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=4 guibg=#d291e4
"" Vim
augroup END

" set highlight cursor
augroup CursorLine
"  au!
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
augroup END

set mouse+=a

if has("autoread")
    " Reload .vimrc immediately when edited
    set autoread
else
    " Reload .vimrc immediately when edited
    autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim
endif

" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME
" === list settings ===
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.
" ------------------------------------------------
"  diff mode for commits
" ------------------------------------------------
au BufNewFile COMMIT_EDITING let syntax = diff
augroup END

" Make Arrow Keys work
imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m

if !empty(glob('$HOME/.config/nvim/iron.plugin.lua')) 
    silent! luafile $HOME/.config/nvim/iron.plugin.lua
endif

" === fold settings ==

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level


" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>
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
  \ 'set_tkeymaps': 'NvimGdbNoTKeymaps',
  \ }
"----------------------------------------------
" Plugin: 'fzf.vim'
"----------------------------------------------

" Syntax highlight preview
let g:fzf_preview_highlighter = 'highlight -O xterm256 --line-number --style rdark --force'

" Files with bat previewer
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat -p --color always {}']}, <bang>0)
"----------------------------------------------
" Plugin: vimwiki/vimwiki
"----------------------------------------------
let g:vimwiki_list = [{'path': '~/projects/Apollo/wiki',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
"----------------------------------------------
" Plugin: 'vimwiki/vimwiki'
"----------------------------------------------
let g:vimwiki_ext2syntax = {'.md': 'markdown',
                  \ '.mkd': 'markdown',
                  \ '.wiki': 'media'}

"---------------------------------------------
" Plugin'tpope/vim-markdown'
"----------------------------------------------
let g:markdown_fenced_languages = ['html', 'css', 'scss', 'sql', 'javascript', 'go', 'python', 'bash=sh', 'c', 'ruby', 'zsh', 'yaml', 'json' ]
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

" --------------------------------------------
" Plugin: 'numirias/semshi'
" --------------------------------------------
nmap <silent> <F4> :Semshi toggle<CR>
function! SemhiOneHighlights()
    hi semshiLocal           ctermfg=209 guifg=#e88388
    hi semshiGlobal          ctermfg=214 guifg=#c678dd
    hi semshiImported        ctermfg=214 guifg=#56b6c2 cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#61AFEF
    hi semshiParameterUnused ctermfg=117 guifg=#56b6c2
    hi semshiFree            ctermfg=218 guifg=#ffafd7
    hi semshiBuiltin         ctermfg=207 guifg=#c678dd
    hi semshiAttribute       ctermfg=49  guifg=#a7cc8c
    hi semshiSelf            ctermfg=249 guifg=#abb2bf
    hi semshiUnresolved      ctermfg=226 guifg=#e5c07b cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#c678dd guibg=#353a44 

    hi semshiErrorSign       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
    hi semshiErrorChar       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
endfunction

autocmd FileType python call SemhiOneHighlights()
" 

"----------------------------------------------
" Plugin: 'Vigemus/iron.nvim'
"----------------------------------------------
luafile $HOME/.config/nvim/iron.plugin.lua

"----------------------------------------------
" Plugin: 'davidhalter/jedi-vim'
"----------------------------------------------
" disable autocompletion, we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = 'right'
" <leader>n: show the usage of a name in current file
" <leader>r: rename a name

" let g:deoplete#sources#jedi#extra_path = ['/dev/shm/fbcode-vimcache']

if has('python3') && has('*jed*') && exists('*jedi#init_python') && jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
    if exists("$VIRTUAL_ENV")
        let g:python_host_prog=substitute(system('which -a python | head -n1 | tail -n1'), '\n', '', 'g')
        let g:python3_host_prog=substitute(system('which -a python3 | head -n1 | tail -n1'), '\n', '', 'g')
        let g:jedi#force_py_version='3'
    else
        let g:python_host_prog=substitute(system("which python"), '\n', '', 'g')
        let g:python3_host_prog=substitute(system('which python3'), '\n', '', 'g')
    endif
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif

let g:deoplete#auto_complete_delay = 10

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
" use tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:jedi#show_call_signatures = "1"
augroup deopleteExtre
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup  END

" call this again
call deoplete#initialize()
"----------------------------------------------
" Plugin: 'w0rp/ale'
"----------------------------------------------
" Gutter Error and warning signs.
let g:ale_sign_error = '窱'
let g:ale_sign_warning = '碌'

let g:ale_linters_explicit = 1
let g:ale_linters = { 'python' : ['flake8', 'pyre'], 
                    \ 'vim' : ['vint'],
                    \ 'sh' : ['shellcheck'],
                    \ 'terraform' : ['tflint'],
                    \ }
" " Fix Python files with autopep8 and yapf.
let g:ale_fixers = { 'python' : ['black' ],
            \       'lua' : ['trimwhitespace', 'remove_trailing_lines'],
            \        'terraform' : ['terraform'],
            \        'json' : ['jq'] }
let g:ale_python_mypy_options = '--ignore-missing-imports'

let g:ale_python_flake8_args = '--max-line-length=' . linelen
let g:ale_python_flake8_options = '--max-line-length=' . linelen

let g:ale_fix_on_save = 0
let g:ale_set_loclist = 0
" Us quickfix with 'qq' delete
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
let g:ale_keep_list_window_open = 1
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
let g:webdevicons_enable_denite = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1



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

" Run lint on these file types.
au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"

"----------------------------------------------
" Plugin 'mhinz/vim-startify' 
"----------------------------------------------
" add webdev icon
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

"----------------------------------------------
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------

if has('macunix')
    let g:os=''
elseif has('win32unix')
    let g:os=''
elseif has('win32')
    let g:os=''
elseif has('unix')
    if $DISTRO ==? 'Redhat'
        let g:os=''
    elseif $DISTRO ==? 'Ubuntu'
        let g:os=''
    elseif $DISTRO ==? 'Debian'
        let g:os=''
    else
        let g:os=''
    endif
else
    let g:os=''
endif

let g:os_spec_string=' n' . g:os . (has("gui_running")?'': '').('')

let g:lightline = {
      \ 'inactive': {
      \   'left': [ [  'pyenv', 'pyenv_active', ],
      \             [ 'fugitive', 'filename', 'tagbar' ],
      \             [ 'readonly', 'lineinfo', 'linecount'], 
      \           ],
      \   'right': [ 
      \             [ 'filetype', 'fileformat'],
      \             [ 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \            ]
      \ },
      \ 'active': {
      \   'left': [ [  'mode', 'paste', 'spell',
      \                'pyenv', 'pyenv_active', ],
      \             [ 'fugitive', 'filename', 'tagbar', ],
      \           ],
      \   'right': [ 
      \             [ 'readonly', 'percent', 'lineinfo',  'linecount',  ], 
      \             [ 'readonly', 'filetype', 'fileformat', ],
      \             [ 'linter_checking', 'linter_errors',
      \                'linter_warnings', 'linter_ok' ],
      \            ]
      \ },
      \ 'component_expand' : {
      \  'linter_checking': 'g:lightline#ale#checking',
      \  'linter_warnings': 'g:lightline#ale#warnings',
      \  'linter_errors': 'g:lightline#ale#errors',
      \  'linter_ok': 'g:lightline#ale#ok',
      \  'pyenv': 'pyenv#pyenv#get_activated_env',
      \  'gitbranch': 'fugitive#head',
      \ },
      \ 'component': {
      \   'lineinfo': '%{line(".")}',
      \   'linecount': '%{line("$")}',
      \   'close': '%9999X%{g:os_spec_string}', 
      \   'tagbar': '%{tagbar#currenttag("%s", "")}',
      \   'spell': '%{&spell?&spelllang:""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{&filetype=="help"?"":exists("*LightlineFugitive")?LightlineFugitive():""}',
      \   'pyenv_active': '%{&filetype!="python"?"":exists("pyenv#pyenv#is_activated")&&pyenv#pyenv#is_activated()?WebDevIconsGetFileTypeSymbol("main.py", 1):""}',
      \ },
      \ 'component_visible_condition': {
      \     'linecount': '(winwidth(0) > getbufvar("b:", "small_threshold", g:small_threshold))',
      \     'lineinfo': '(winwidth(0) > getbufvar("b:", "small_threshold", g:small_threshold))',
      \     'linter_checking': '(index(g:lightline_blacklist,&filetype)==-1)',
      \     'fileformat' : '(winwidth(0) > getbufvar("b:", "medium_threshold", g:medium_threshold))',
      \     'linter_warnings': '(index(g:lightline_blacklist,&filetype)==-1)',
      \     'linter_errors': '(index(g:lightline_blacklist,&filetype)==-1)',
      \     'linter_ok': '(index(g:lightline_blacklist,&filetype)==-1)',
      \     'close': '(index(g:lightline_blacklist,&filetype)==-1)',
      \     'spell': '(winwidth(0)>=getbufvar("b:", "medium_threshold", g:medium_threshold)&&index(g:lightline_blacklist,&filetype)==-1)',
      \     'readonly': '(index(g:lightline_blacklist,&filetype)==-1&&(&readonly))',
      \     'modified': '(!(&readonly)&&index(g:lightline_blacklist,&filetype)!=-1&&(modified||!&modifiable))',
      \     'fugitive': '(index(g:lightline_blacklist,&filetype)==-1&&exists("*FugitiveStatusline") && ""!=FugitiveStatusline() && winwidth(0)>=getbufvar("b:", "small_threshold", g:small_threshold))',
      \     'paste': '(index(g:lightline_blacklist,&filetype)==-1&&(&paste))',
      \     'pyenv': '(&filetype=="python"&&exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated()&&winwidth(0)>getbufvar("b:", "small_threshold", g:small_threshold))',
      \     'pyenv_active': '(&filetype=="python"&&exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated())',
      \     'method': '(index(g:lightline_blacklist,&filetype)!=-1&&winwidth(0)>=getbufvar("b:", "medium_threshold", g:medium_threshold)&&getbufvar("vista_nearest_method_or_function","")!==#"")',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \     'pyenv_active': 'ok',
      \     'banner': 'tabsel',
      \ },
      \ 'component_function': {
      \     'mode': 'LightlineMode',
      \     'filetype': 'MyFiletype',
      \     'fileformat': 'MyFileformat',
      \    'method': 'NearestMethodOrFunction'
      \ },
      \ 'tabline' : {
      \   'separator': { 'left': '┋', },
      \   'active': [ 
      \       'tabnum', 'filename', 'modified', 'readonly',
      \   ],
      \ },
      \ 'tab_component_function': {
      \ 'filename': 'LightlineTabname',
      \ 'modified': 'LightlineTabmodified',
      \ 'readonly': 'LightlineTabReadonly',
      \ 'tabnum': 'LightlineTabNumber',
      \ 'banner': 'LightlineBanner',
      \ },
      \ 'colorscheme' : 'one',
      \   'separator': { 'left': '', 'right':'' },
      \   'subseparator': { 'left': '∶', 'right': '∷'},
      \ }

function! LightlineMode()
  let l:tabname=expand('%:t')
  return l:tabname ==# '__Tagbar__' ? 'Tagbar':
        \ l:tabname ==# 'NERDTree' ? '' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

let g:lightline#pyenv#indicator_ok = ''
function! LightlineTabmodified(n) abort
    let winnr = tabpagewinnr(a:n)
    let buflist = tabpagebuflist(a:n)
    let fname = expand('#'.buflist[winnr - 1].':t')
    let buf_modified = gettabwinvar(a:n, winnr, '&modified') ? '﯂' : ''
    return ( '' !=? fname ? buf_modified : '')
endfunction

function! LightlineTabReadonly (n) abort
    let winnr = tabpagewinnr(a:n)
      return gettabwinvar(a:n, winnr, '&readonly') ? '' : gettabwinvar(a:n, winnr, '&modifiable') ? '' : ''
endfunction

function! LightlineTabNumber(n) abort
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let fname = expand('#'.buflist[winnr - 1].':t')
    " [ buf# ] [icon|]
    " expand('%:t:r')
    return ( WebDevIconsGetFileTypeSymbol(fname, isdirectory(fname)) . string(a:n) )
endfunction
" https://github.com/inkarkat/vim-StatusLineHighlight/blob/master/plugin/StatusLineHighlight.vim
function! LightlineTabname(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fname = expand('#'.buflist[winnr - 1].':t')
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' : 
        \ ('' !=? fname ? fname : '﬒')
endfunction

function! LightlineFugitive()
  if &filetype !~? 'vimfiler' && exists('*fugitive#head')
    let branch = fugitive#head()
    if len(branch) < 25
      return branch
    endif
    return branch[:15] . ' .. ' . branch[(len(branch)-15):]
  endif
  return ''
endfunction
"  
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
                \ globpath(&runtimepath,'autoload/lightline/colorscheme/*.vim',1,1),
                \ 'fnamemodify(v:val,":t:r")'),
                \ '\n')
endfun

com! -nargs=1 -complete=custom,s:lightlineColorschemes LightlineColorscheme
            \ call s:setLightlineColorscheme(<q-args>)

function! s:LightLineUpdateColor()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
    " inject center bar blank into pallete (an interesting hack)
    let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    "let s:palette.inactive.middle = s:palette.normal.middle
    let s:palette.tabline.middle = s:palette.normal.middle
endfunction

com! -nargs=0 ToggleColor
    \ call s:LightLineUpdateColor()

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! MyFiletype()
    let symbol=WebDevIconsGetFileTypeSymbol() 
    let new_ft=(strlen(&filetype) ? symbol . ' ' . &filetype  : '')
    return winwidth(0) > 120 ?  new_ft : symbol
endfunction

function! MyFileformat()
    let symbol=WebDevIconsGetFileFormatSymbol()
    return ((winwidth(0) > 80) ? symbol . ' ' . &fileformat : symbol )
endfunction

let g:lightline#ale#indicator_checking = ''
let g:lightline#ale#indicator_warnings = ''
let g:lightline#ale#indicator_errors = ''
let g:lightline#ale#indicator_ok = ''

"----------------------------------------------
" Plugin: bling/vim-go
"----------------------------------------------
"
let g:go_auto_sameids = 1
let g:go_fmt_command = 'goimports'

augroup GOHELPERS
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
let g:go_addtags_transform = 'snakecase'
augroup END

"----------------------------------------------
" Plugin: christoomey/vim-tmux-navigator
"----------------------------------------------
" Tmux vim integration
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 1
if exists('$TMUX')
    augroup TMUX_TITLE
    autocmd WinEnter,TabEnter,BufWritePost * call system("tmux rename-window '" . expand('%:t') . "'")
    autocmd VimLeavePre * call system("tmux rename-window '-'")
augroup END
    " tmux will send xterm-style keys when its xterm-keys option is on
    if &term =~? '^screen'
        execute 'set <xUp>=\e[1;*A'
        execute 'set <xDown>=\e[1;*B'
        execute 'set <xRight>=\e[1;*C'
        execute 'set <xLeft>=\e[1;*D'
    endif

    let g:tmux_navigator_save_on_switch = 1

    " Move between splits with ctrl+h,j,k,l
    nnoremap <silent> <leader><c-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <leader><c-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <leader><c-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <leader><c-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <leader><c-\> :TmuxNavigatePrevious<cr>
endif

if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
else
    augroup TMUX_RENAME
        autocmd BufEnter * call system("tmux rename-window '" . tabpagenr() . ' ' . LightlineTabname(tabpagenr()) . ' ' . LightlineTabmodified(tabpagenr()) . "'")
        autocmd VimLeave * call system('tmux setw automatic-rename")
    augroup END
endif

"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggle<cr>

let NERDTreeShowBookmarks=1
" Allow NERDTree to change session root.
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0

" Show hidden files by default.
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

augroup nerdtree_extra
" Close vim if NERDTree is the only opened window.
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif
augroup END

let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Ignored'   : '☒',
    \ 'Unknown'   : '?'
    \ }

function! NERDTreeYankCurrentNode()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
        call setreg('=', n.path.str())
        call setreg('+', n.path.str())
    endif
endfunction

if exists('NERDTreeAddKeyMap')
call NERDTreeAddKeyMap({
        \ 'key': 'yy',
        \ 'callback': 'NERDTreeYankCurrentNode',
        \ 'quickhelpText': 'put full path of current node into the default register' })
endif

" Show hidden files by default.
let NERDTreeShowHidden = 1

" Allow NERDTree to change session root.
let g:NERDTreeChDirMode = 2

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0

let g:webdevicons_enable_nerdtree = 1
" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
" --------------------
" Plug 'bfredl/nvim-ipy'
" --------------------
let g:ipy_perform_mappings=1

" --------------------
" Plugin 'janko/vim-test'
" --------------------
augroup VIMTEST_KEYMAP
autocmd FileType * call s:vim_test_keymap()
augroup END

function! s:vim_test_keymap()
    nmap <silent> t<C-n> :TestNearest<CR>
    nmap <silent> t<C-f> :TestFile<CR>
    nmap <silent> t<C-s> :TestSuite<CR>
    nmap <silent> t<C-l> :TestLast<CR>
    nmap <silent> t<C-g> :TestVisit<CR>
endfunction

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
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" { :set sw=2 ts=2 et }
