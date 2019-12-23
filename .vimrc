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

" Reload .vimrc immediately when edited
augroup AUTOUPDATE
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
augroup END

if isdirectory('~/.config/nvim/plugged')
    call plug#begin('~/.config/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
" colorscheme
colorscheme default
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
" Plugin 'ryanoasis/vim-devicons'
"----------------------------------------------
let g:webdevicons_enable_unite = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
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

let g:os_spec_string=' ' . g:os . (has('gui_running')?'': '').('')

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
      \   'readonly': '(index(["help","nofile"],&filetype)!=-1&& &readonly)',
      \   'modified': '(index(["help","nofile"],&filetype)!=-1&&(&modified||!&modifiable))',
      \   'fugitive': '(index(["help","nofile"],&filetype)!=-1&&(winwidth(0) <80)&&exists("*FugitiveStatusline") && ""!=FugitiveStatusline())',
      \   'pyenv_active': '(&filetype!="python"&&exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated())',
      \   'tagbar': '(exists("tagbar#currenttag"))',
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
if exists('$TMUX') || ! empty('TMUX')
    augroup TMUX_TITLE
        let g:tmux_window_name=system('tmux display-message -p "\#W"')
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name
        autocmd WinEnter,TabEnter,BufWritePost * call system("tmux rename-window '" . expand('%:t') . "'")
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name
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
  if (has('nvim'))
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
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
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
