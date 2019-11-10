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
    set guifont=Hack\ Nerd\ Font:h12
endif

" memory leak problem
if v:version >= 702
    augroup CLEARMATCHES
    autocmd BufWinLeave * call clearmatches()
    augroup END
endif

set mouse+=a
if has('ttymouse') && ( &term =~? '^screen' || &term =~? '^xterm' )
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME

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
set history=1000

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

set clipboard=unnamed

if exists('$VIRTUAL_ENV')
    let g:python_host_prog=substitute(system('which -a python3 | head -n2 | tail -n1'), '\n', '', 'g')
endif

" === Auto install plug.vim ===
let autoload_plug_path = '~/.vim/autoload/plug.vim'
augroup plug_auto_update
if ! empty(glob(autoload_plug_path))
    exec 'set rtp=' . autoload_plug_path . ',' . &runtimepath
elseif empty(glob(autoload_plug_path))
  silent ! exec '!curl -fLo ' . autoload_plug_path . 
                \ ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  source &autoload_plug_path
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
    exec 'set runtimepath=' . autoload_plug_path . ',' . &runtimepath
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
augroup END

unlet autoload_plug_path
" Reload .vimrc immediately when edited
augroup AUTOUPDATE
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
augroup END

if isdirectory('~/.config/nvim/plugged')
    call plug#begin('~/.config/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

" --- Colorscheme ---
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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/ag.vim'

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'


Plug 'majutsushi/tagbar'

" Linting, syntax, autocomplete, semantic highlighting Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'w0rp/ale'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/context_filetype.vim'

Plug 'tmhedberg/SimpylFold'

Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

Plug 'jez/vim-superman'

Plug 'ekalinin/Dockerfile.vim'
Plug 'kevinhui/vim-docker-tools'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'towolf/vim-helm'

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

" --- languages
Plug 'ekalinin/Dockerfile.vim'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'towolf/vim-helm'
Plug 'saltstack/salt-vim'
Plug 'hashivim/vim-terraform'

call plug#end()

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
" colorscheme

if (has('gui_running'))
    silent! colorscheme tender
    silent! LightlineColorScheme tenderplus
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
let linelen=120
execute 'set colorcolumn='.linelen
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
execute 'match OverLength /\%'.linelen.'v.\+/'

    " set highlight cursor
    "augroup CursorLine
    "  au!
    "  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    "  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
    "  au WinLeave * setlocal nocursorline
    "augroup END

augroup AUTOUPDATE
" Reload .vimrc immediately when edited
autocmd! bufwritepost vimrc source ~/.vimrc
augroup END
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
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=grey guibg=#d291e4
"" Vim
augroup END

" set highlight cursor
augroup CursorLine
"  au!
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
augroup END

let g:easytags_dynamic_files = 1
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
"
augroup FILETYPES
:au BufNewFile,BufRead *.jinja set filetype=jinja
:au BufNewFile,BufRead *.zsh,*.bash let l:linelen=240

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
                    \ 'json' : ['jq'] ,
                    \ }
" " Fix Python files with autopep8 and yapf.
let g:ale_fixers = { 'python' : ['black' ],
            \       'lua' : ['trimwhitespace', 'remove_trailing_lines'],
            \        'terraform' : ['terraform'] }
let g:ale_python_mypy_options = '--ignore-missing-imports'

let g:ale_python_flake8_args = '--max-line-length=' . linelen
let g:ale_python_flake8_options = '--max-line-length=' . linelen

let g:ale_fix_on_save = 0
let g:ale_set_loclist = 0
" Us quickfix with 'qq' delete
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
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
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------



let g:lightline = {
      \ 'inactive': {
      \   'left': [ [ 'filename', 'tagbar' ],
      \             [ 'readonly', 'lineinfo', 'linecount'], 
      \           ],
      \   'right': [ 
      \             [ 'filetype', 'fileformat'],
      \             [ 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \            ]
      \ },
      \ 'active': {
      \   'left': [ [  'mode', 'paste', 'spell', ],
      \             [  'filename', 'tagbar', ],
      \           ],
      \   'right': [ 
      \             [ 'readonly', 'percent', 'lineinfo',  'linecount',  ], 
      \             [ 'readonly', 'filetype', 'fileformat', ],
      \             [ 'linter_checking', 'linter_errors',
      \                'linter_warnings', 'linter_ok' ],
      \            ]
      \ },
      \ 'component': {
      \   'lineinfo': '%{line(".")}',
      \   'linecount': '%{line("$")}',
      \   'close': '%9999X%{g:os_spec_string}', 
      \   'tagbar': '%{tagbar#currenttag("%s", "")}',
      \   'spell': '%{&spell?&spelllang:""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(index(["help","nofile"],&filetype)!=-1&& &readonly)',
      \   'modified': '(index(["help","nofile"],&filetype)!=-1&&(&modified||!&modifiable))',
      \   'tagbar': '(exists("tagbar#currenttag"))',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ 'component_function': {
      \     'mode': 'LightlineMode',
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
      \ },
      \ 'colorscheme' : 'PaperColor_' . &background,
      \   'separator': { 'left': '', 'right':'' },
      \   'subseparator': { 'left': '∶', 'right': '∷'},
      \ }

function! LightlineMode()
  let l:tabname=expand('%:t')
  return l:tabname ==# '__Tagbar__' ? 'Tagbar':
        \ l:tabname ==# 'NERDTree' ? '' :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

" https://github.com/inkarkat/vim-StatusLineHighlight/blob/master/plugin/StatusLineHighlight.vim
function! LightlineTabname(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fname = expand('#'.buflist[winnr - 1].':t')
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' : 
        \ ('' !=? fname ? fname : '-')
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
if exists('$TMUX') || ! empty("TMUX")
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
