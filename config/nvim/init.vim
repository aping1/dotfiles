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

set fillchars+=fold:─
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
let g:dein_file=(expand('<sfile>:p:h') . '/00-dein.vim')


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

"----------------------------------------------
" Plugin: 'davidhalter/jedi-vim'
"----------------------------------------------
"
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled=0
" disable autocompletion, this vimrc uses ale for completion
let g:jedi#show_call_signatures = 1
" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = 'right'
" <leader>n: show the usage of a name in current file
" <leader>r: rename a nameexists('pyenv#python*') 
function! s:SetupJedcommands()
    let g:jedi#goto_command = "<leader>d"
    let g:jedi#goto_assignments_command = "<leader>g"
    let g:jedi#goto_stubs_command = "<leader>s"
    let g:jedi#goto_definitions_command = "<leader>R"
    " let g:jedi#documentation_command = "K"
    let g:jedi#usages_command = "<leader>n"
    let g:jedi#completions_command = "<C-Space>"
    let g:jedi#rename_command = "<leader>r"
endfunction

" function that sets host prog from inherited shell
function! s:python_from_environment(py2_sel, py3_sel)
    let g:jedi#force_py_version='3'
    if exists("$VIRTUAL_ENV")
        let g:python_host_prog=substitute(system('command -v python'), '\n', '', 'g')
        let g:python3_host_prog=substitute(system('command -v python3'), '\n', '', 'g')
    else
        let g:python_host_prog=substitute(system('type -a python | awk "NR=='. a:py2_sel .'{print \$NF}"'), '\n', '', 'g')
        let g:python3_host_prog=substitute(system('type -a python3 | awk "NR=='. a:py3_sel .'{print \$NF}"'), '\n', '', 'g')
    endif
endfunction

" for pyenv ...
if exists('*pyenv#pyenv#is_enabled') && pyenv#pyenv#is_enabled()
    function! s:python_prefixes() abort " {{{
        if ! exists('*pyenv#pyenv#is_enabled()') || ! pyenv#pyenv#is_enabled()
            return []
        endif
        let result = pyenv#utils#system(join([
                \ g:pyenv#pyenv_exec,
                \ 'prefix',
                \]))
        if result.status == 0
            return split(result.stdout, '\v\r?\n')
        endif
        return []
    endfunction " }}}
    command! -nargs=0 PythonPrefixes call setreg('+', s:python_prefixes()[0])
    if exists('$PYENV_VIRTUAL_INIT')
        autocmd VimEnter python silent! command PyenvActivate 
    endif
    function! s:pyenv_init()
        " Active external version
        "pyenv#info#format('%iv') A version of the internal python
        "pyenv#info#format('%im') " A major version of the internal python
        "pyenv#info#format('%ev') "A version of the external python
        "pyenv#info#format('%em') "A major version of the external python
        "pyenv#info#format('%sv') "A selected version name
        "pyenv#info#format('%ss') "A selected version names
        "pyenv#info#format('%av') "An activated version name
        if exists('*jedi#init_python') && jedi#init_python()
            let g:jedi#force_py_version='3'
        endif
        " if active, 
        if exists('*pyenv#pyenv#is_activated') && pyenv#pyenv#is_activated() && pyenv#python#get_external_major_version()
            "pyenv#info#format('%iv') A version of the internal /usr/bin/python
            if pyenv#python#get_internal_major_version() >= 2
                let g:jedi#force_py_version=pyenv#python#get_internal_major_version()
            else 
                let g:jedi#force_py_version=3
            endif 
            if pyenv#python#get_external_major_version() == 2 
                " in the case it's 2. we just use the one from the environment
                let g:python_host_prog=g:pyenv#python_exec . '2'
                let g:python3_host_prog=substitute(system('type -a python3 | awk "NR==2{print \$NF}"'), '\n', '', 'g')
                let g:jedi#force_py_version=2
            elseif pyenv#python#get_external_major_version() > 0
                let g:jedi#force_py_version=pyenv#python#get_external_major_version()
                if g:pyenv#python_exec =~ '[[:digit:].]\+$'
                    let g:python_host_prog=g:pyenv#python_exec . '2'
                    let g:python3_host_prog=g:pyenv#python_exec
                endif 
            endif
        else
            call s:python_from_environment("2", "2")
        endif
        " for vim-test
        let g:test#python#runner = g:python3_host_prog
        let g:test#python#pyunit#executable =  g:python3_host_prog .  '-m pyunit'
        " set the virtual env python used to launch the debugger
        let g:pudb_breakpoint_symbol='☠'
        let g:pyenv_path = s:python_prefixes()[0]
    endfunction
    augroup vim-pyenv-custom-augroup
        autocmd User vim-pyenv-activate-post   call s:pyenv_init()
        autocmd User vim-pyenv-deactivate-post call s:pyenv_init()
    augroup END
else
    call s:python_from_environment("1", "1")
endif

" let g:deoplete#auto_complete_delay = 10
" Required for Semshi > 100
"let g:deoplete#auto_complete_delay = 100
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
"let g:deoplete#sources#jedi#show_docstring=1

" let g:deoplete#sources#jedi#statement_length=linelen
" call deoplete#custom#option({'auto_complete': v:false})
autocmd FileType Python call deoplete#custom#source('_', 'sources', ['ale','coc']) | call deoplete#custom#option({'auto_complete_delay': 100})
"deoplete#custom#option(
"            \'{auto_complete': { '_', v:false}, 
"            \ 'sources': ['ale'],
"            \})

filetype plugin indent on
syntax enable
autocmd VimResized * wincmd =

set background=dark

set cmdheight=2
" To use a custom highlight for the float window,

"----------------------------------------------
" Plugin: 'mhinz/vim-startify'
"----------------------------------------------
" augroup numbertoggle
" autocmd BufEnter * if !exists('t:startified') | Startify | let t:startified = 1 | endif
"autocmd BufEnter python :CocDisable
"autocmd BufLeave python :CocEnable
" augroup END

"----------------------------------------------
" Plugin: 'nathanaelkane/vim-indent-guides'
"----------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size = 2
let g:indent_guides_start_level = 2


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

" Make Arrow Keys work
imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" Adds for IronRepl: PickRepl PickVirtualEnv PickIPython
"if !empty(glob('$HOME/.config/nvim/iron.plugin.lua')) 
"    silent! luafile $HOME/.config/nvim/iron.plugin.lua
"endif

" === fold settings ==
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

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
" Plugin: 'ack.vim'
"----------------------------------------------
if executable('ag')
    " NOTE: vimgrep not supported with dispatch
    let g:ack_use_dispatch=0
    let g:ackprg = 'ag --vimgrep --follow --nocolor --hidden --silent'
    set grepprg=g:ackprg
    set grepformat=%f:%l:%c:%m
endif

"----------------------------------------------
" Plugin: 'fzf.vim'
"----------------------------------------------
" Syntax highlight preview
if executable('highlight')
    let g:fzf_preview_highlighter = 'highlight -O xterm256 --line-number --style rdark --force'
endif

let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_directory_files_command = 'fd -l --hidden --follow --no-messages' 
let g:fzf_preview_grep_cmd = g:ackprg
" Files with bat previewer
if executable('bat')
    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat -p --style snip --color always {}']}, <bang>0)
endif

"----------------------------------------------
" Plugin: vimwiki/vimwiki
"----------------------------------------------
let g:vimwiki_list = [{
            \ 'path': '~/Dropbox/wiki',
            \ 'syntax': 'markdown',
            \ 'ext': '.md'
            \ }]

"----------------------------------------------
" Plugin: 'vimwiki/vimwiki'
"----------------------------------------------
let g:vimwiki_ext2syntax = {
            \ '.md': 'markdown',
            \ '.mkd': 'markdown',
            \ '.wiki': 'media'}

"----------------------------------------------
" Plugin: 'Vigemus/iron.nvim'
"----------------------------------------------
"luafile $HOME/.config/nvim/iron.plugin.lua


"----------------------------------------------
"        Plugin: Shougo/echodoc.vim
"----------------------------------------------
let g:echodoc#enable_at_startup=1
let g:echodoc#type="floating"


augroup deopleteExtra
    " autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    "autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd!
    autocmd FileType * if exists(":UltiSnipsAddFiletypes") | exe 'UltiSnipsAddFiletypes ' . &filetype  | endif
augroup  END

"----------------------------------------------
" Plugin: 'w0rp/ale'
"----------------------------------------------
" Gutter Error and warning signs.

let g:ale_enabled=1
let g:ale_virtualtext_prefix=' '
" let g:ale_echo_delay=15
let g:ale_hover_to_preview=0
" preview window
" let g:ale_virtualtext_delay=15
let g:ale_sign_column_always=1
let g:ale_set_balloons=1
let g:ale_virtualtext_cursor=1
" errors at cursor (in preview window)
let g:ale_echo_cursor=1
" shows details for err i cure
let g:ale_cursor_detail=0

let g:ale_lint_on_insert_leave = 1
let g:ale_close_preview_on_insert=0
let g:ale_lint_on_enter = 1
let g:ale_completion_enabled = 0
let g:ale_sign_error = '窱'
let g:ale_sign_warning = '碌'

" Auto import with typescript`
let g:ale_completion_tsserver_autoimport = 1
let g:ale_python_pyls_use_global=1
let g:ale_python_pyls_use_autoenv=1

let g:ale_linter_aliases = {
            \ 'jsx': ['css', 'javascript'],
            \ }
let g:ale_linters_explicit = 1
let g:ale_linters = { 'python' : ['flake8'], 
            \ 'c' : ['cppcheck'],
            \ 'vim' : ['vimls', 'coc'],
            \ 'sh' : ['shellcheck'],
            \ 'zsh' : ['deoplete-zsh'],
            \ 'terraform' : ['tflint'],
            \ 'jsx' : ['stylelint', 'eslint'],
            \ 'json' : ['jsonlint'],
            \ 'dockerfile' : ['hadolint'],
            \ }

" " Fix Python files with autopep8 and yapf.
let g:ale_fixers = { 'python' : ['black' ],
            \ 'c' : ['clang-format', 'remove_trailing_lines'],
            \ 'lua' : ['trimwhitespace', 'remove_trailing_lines'],
            \ 'terraform' : ['terraform'],
            \ 'json' : ['prettier'] }

let g:ale_python_mypy_options = '--ignore-missing-imports'

let g:ale_python_flake8_args = '--max-line-length=' . linelen
let g:ale_python_flake8_options = '--max-line-length=' . linelen

let g:ale_fix_on_save = 0
" Us quickfix with 'qq' delete
" quickfix can be set with 'nvim -d FILENAME' so use loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
let g:ale_keep_list_window_open = 1
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
let g:ale_completion_tsserver_autoimport = 1
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd Filetype css,json setlocal tabstop=1 shiftwidth=2 expandtab 
augroup END
" ['stylelint', 'eslint']

" user environment
let g:ale_virtualenv_dir_names = []

let g:ale_python_auto_pipenv = 1

"let l:stl .= '%{s:ale_running ? "[linting]" : ""}'
"augroup ALEProgress
"    autocmd!
"    autocmd User ALELintPre  let s:ale_running = 1 | redrawstatus
"    autocmd User ALELintPost let s:ale_running = 0 | redrawstatus
"augroup END

" References: /Users/aping1/.dotfiles/config/nvim/autoload/mappings.vim


"----------------------------------------------
" Plugin 'ryanoasis/vim-devicons'
"----------------------------------------------
let g:webdevicons_enable_denite = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
" Run lint on these file types.
au FileType xml exe ":silent 1, $!xmllint --format --recover - 2> /dev/null"

if has('macunix')
    let g:os=''
elseif has('win32unix')
    let g:os='  '
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

let g:os_spec_string=' n ' . g:os . ' '. (has("gui_running")?'': '').(' ')


" --------------------
" Plugin: ncm2/float-preview.nvim
" --------------------
function! DisableExtras()
  call nvim_win_set_option(g:float_preview#win, 'number', v:true)
  call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:true)
  call nvim_win_set_option(g:float_preview#win, 'cursorline', v:true)
endfunction
let g:float_preview#auto_close = 1

autocmd User FloatPreviewWinOpen call DisableExtras()

"----------------------------------------------
" Plugin: bling/vim-go
"----------------------------------------------
let g:go_auto_sameids = 1
let g:go_fmt_command = 'goimports'

augroup GOHELPERS
    autocmd!
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

"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
"nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggleVCS<cr>

let g:webdevicons_enable_nerdtree = 1
" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:webdevicons_conceal_nerdtree_brackets = 1


" --------------------
" Plug 'bfredl/nvim-ipy'
" --------------------
let g:ipy_perform_mappings=0
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)%(\ -\ %{g:ipy_status}%)
let g:ipy_celldef = '^##'
let g:ipy_shortprompt=1


augroup VIMTEST_KEYMAP
  au!
  autocmd User NeomakeJobFinished call TestFinished()
  autocmd User NeomakeJobStarted call TestStarted()
augroup END
" --------------------
" Plugin 'janko/vim-test'
" --------------------
augroup VIMTEST_KEYMAP
    autocmd!
    autocmd FileType * call s:vim_test_keymap()
augroup END

function! s:vim_test_keymap()
    nmap <silent> t<C-n> :TestNearest<CR>
    nmap <silent> t<C-f> :TestFile -strategy=dispatch<CR>
    nmap <silent> t<C-s> :TestSuite<CR>
    nmap <silent> t<C-l> :TestLast<CR>
    nmap <silent> t<C-g> :TestVisit<CR>
endfunction
let g:test#python#runner = g:python3_host_prog
let g:test#python#pyunit#executable =  g:python3_host_prog .  '-m pyunit'
let g:test#strategy = "dispatch"
" make test commands execute using dispatch.vim
let g:dispatch_handlers=["iterm", "tmux", "neovim", "job", "screen", "windows", "x11", 'headless']

let g:dash_map = {
            \ 'c' : ['cpp']
            \ }

autocmd QuickFixCmdPost * if exists('*g:float_preview#reopen') | call float_preview#reopen() | endif
" plugin neoclide/coc.nvim

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" --------------------
" Plugin: liuchengxu/vista.vim
" --------------------
" By default vista.vim never run if you don't call it explicitly.
" show the nearest function in your statusline automatically,
augroup VistaHooks
autocmd!
autocmd VimEnter * if exists("*vista#RunForNearestMethodOrFunction") | call vista#RunForNearestMethodOrFunction() | endif
"autocmd Filetype python,json 'nmap <s-CR> :call vista#cursor#ShowTag()<cr>'
augroup END

" --------------------
" Plugin: blueyed/vim-qf_resize')
" --------------------
" defualt 1
let g:qf_resize_min_height=5
" default 10
let g:qf_resize_max_height=20
" default .15
let g:qf_resize_max_ratio=0.25
" default 1
"g:qf_resize_on_win_close=1 
set pumheight=15


nnoremap <silent> <c-w>= :wincmd =<cr>:QfResizeWindows<cr>

au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
        " number to float for division
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction


" --------------------
" Plugin: 'SirVer/ultisnips'
"    'honza/vim-snippets'
" -------------------- 
let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"let g:UltiSnipsUsePythonVersion = 2

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

augroup UltiSnips_AutoTrigger
    au!
    au InsertCharPre * silent! call UltiSnips#TrackChange()
    au TextChangedI *  silent! call UltiSnips#TrackChange()
    if exists('##TextChangedP')
        au TextChangedP * silent! call UltiSnips#TrackChange()
    endif
augroup END

nmap <leader>g :Goyo<CR>

" { :set sw=2 ts=2 et }
