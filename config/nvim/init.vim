" FileType js UltiSnipsAddFiletypes javascript-jasmine time to wait for new mapping seq
" ttimeoutlen is used for key code delays
" Credit: https://www.johnhawthorn.com/2012/09/vi-escape-delays/
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
let linelen=120

set fillchars=stlnc:─
" Shift Tab insterts '\t' c-I ^I 
inoremap <S-Tab> <C-V><Tab>

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

" Reload .vimrc immediately when edited
augroup AUTOUPDATE
    autocmd! bufwritepost $MYVIMRC source $MYVIMRC
augroup END

if &compatible
    set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let g:lightline_blacklist=["help","nofile","nerdtree", "vista", "qf"]


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
function! s:SetupJedi()
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
                let g:python_host_prog=g:pyenv#python_exec
                let g:python3_host_prog=substitute(system('type -a python3 | awk "NR==2{print \$NF}"'), '\n', '', 'g')
                let g:jedi#force_py_version=2
            elseif pyenv#python#get_external_major_version() > 0
                let g:jedi#force_py_version=pyenv#python#get_external_major_version()
                if g:pyenv#python_exec =~ '[[:digit:].]\+$'
                    let g:python_host_prog=g:pyenv#python_exec
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


"----------------------------------------------
" Dein
"----------------------------------------------
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    try
        " For more info on TOML and moving plugins...
        " https://github.com/Shougo/dein.vim/blob/aa1da8e43b74c109c49281998eab0e148dc042b2/doc/dein.txt
        let s:toml = '~/.vim/plugins.toml'
        call dein#load_toml(s:toml, {'lazy': 0})
    catch /.*/
        echoerr v:exception
        echomsg 'Error loading ...'
        echomsg 'Caught: ' v:exception
        echoerr 'error ' . s:toml . 'config'
    endtry

    " :DeinUpgrade command using minimal SpaceVim ui
    call dein#add('wsdjeg/dein-ui.vim')
    call dein#add('vim-vdebug/vdebug')
    " Dynamic resize quickfix window
    call dein#add('blueyed/vim-qf_resize')

    " --- Sesnible defaults ---
    call dein#add('tpope/vim-sensible')

    " --- TMUX Integration ctrl-hjkl % copy/paste
    call dein#add('tmux-plugins/vim-tmux-focus-events')
    call dein#add('roxma/vim-tmux-clipboard')

    " --- Colorscheme ---
    call dein#add('flazz/vim-colorschemes')
    call dein#add('iCyMind/NeoSolarized')
    call dein#add('jacoborus/tender.vim')
    call dein#add('rakr/vim-one')

    " === Indent lines ===
    call dein#add('nathanaelkane/vim-indent-guides')
    " Highlight colors
    call dein#add('ap/vim-css-color',
                \{'on_ft': ['vim']})
    " Auto color hex
    call dein#add('lilydjwg/Colorizer')

    " Hide sum and such as unicode 
    call dein#add('ryanoasis/vim-devicons')
    " View unicode sets
    call dein#add('chrisbra/unicode.vim', 
                \{'on_ft': 'vim'})
    " Use math symbols instead of keywords 
    " it is very very slow
    " call dein#add('ehamberg/vim-cute-python')
    "
    " --- Denite/Unite
    if has('nvim')
        " Vim exploration Modifications
        call dein#add('Shougo/denite.nvim')
        " call dein#add('dunstontc/denite-mapping')
        call dein#add('Shougo/echodoc.vim')
    else
        call dein#add('Shougo/unite.vim')
        call dein#add('Shougo/unite-outline.vim')
        call dein#add('Shougo/neomru.vim')
        call dein#add('Shougo/vimproc.vim', {
                    \ 'build' : {
                    \     'windows' : 'tools\\update-dll-mingw',
                    \     'cygwin' : 'make -f make_cygwin.mak',
                    \     'mac' : 'make',
                    \     'linux' : 'make',
                    \     'unix' : 'gmake',
                    \    },
                    \ })
    endif

    " manage fzf updates
    call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
    " Use fzf preview 
    " TODO: This doesnt work?
    " call dein#add('yuki-ycino/fzf-preview.vim', { 'rev': 'release' })

    " smarter searching (with ag)
    call dein#add('mileszs/ack.vim')

    " TODO: Impletment Projects
    " project based callbacks to 
    "   Change dir, set gui title, 
    "   add callbacks
    " call dein#add('amiorin/vim-project')
    " --- .projectionist.json --- 
    "  also see ./ftdetect/heuristics.vim
    call dein#add('tpope/vim-projectionist')

    " Smart runner Itegration with projectionist 
    " run tests with alternates
    call dein#add('tpope/vim-dispatch')
    " dispatch windows open in neovim
    call dein#add('radenling/vim-dispatch-neovim')
    " TestFile TestClosest...
    call dein#add('janko/vim-test')

    " Snippet engine 
    call dein#add('SirVer/ultisnips',
                   \{ 'tag': '1.3'})

    call dein#add('honza/vim-snippets')
    call dein#add('srydell/vim-skeleton')

    " Navigation
    call dein#add('jistr/vim-nerdtree-tabs')
    call dein#add('scrooloose/nerdtree',
                \{'on_cmd': ['NERDTreeToggle', 'NERDTreeVCS']})

    call dein#add('Xuyuanp/nerdtree-git-plugin',
                \{'on_cmd': ['NERDTreeToggle', 'NERDTreeVCS']})

    call dein#add('scrooloose/nerdcommenter')
    call dein#add('mg979/vim-visual-multi')

    " Markdown tools
    call dein#add('SidOfc/mkdx',
                \{'on_ft': 'markdown'})
    call dein#add('vimwiki/vimwiki')
    call dein#add('tpope/vim-markdown',
                \{'on_ft': 'markdown'})
    call dein#add('itspriddle/vim-marked',
                \{'on_ft': 'markdown'})
    call dein#add('gyim/vim-boxdraw',
                \{'on_ft': 'markdown'})

    " Git gutter
    call dein#add('mhinz/vim-signify')

    " Version Control
    call dein#add('tpope/vim-fugitive')
    " == mecurial client ==
    call dein#add('ludovicchabant/vim-lawrencium')

    " --- Tags (ctags, lsp)
    call dein#add('liuchengxu/vista.vim')

    " Python virtuel env
    if executable('pyenv')
        call dein#add('lambdalisue/vim-pyenv')
    else
        call dein#add('plytophogy/vim-virtualenv')
    endif

    " --- Autocomplete
    if has('nvim')
       call dein#add('ncm2/float-preview.nvim')
       call dein#add('neoclide/coc.nvim', {
                   \ 'branch': 'release'
                   \ })
                   "\ 'on_cmd': 'command call coc#util#install()'

       "Deoplete framework"
       call dein#add('jsfaint/coc-neoinclude')
       call dein#add('neoclide/coc-snippets')
       call dein#add('neoclide/coc-highlight')
       call dein#add('neoclide/coc-python')

       "" 
       call dein#add('Shougo/neco-vim',
                   \ {'on_ft': 'vim'})
       call dein#add('neoclide/coc-neco',
                   \ {'on_ft': 'vim'})
       " call dein#add('tjdevries/coc-zsh')
       " call dein#add('neovim/nvim-lsp')
    else
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    call dein#add('SkyLeach/pudb.vim', {'on_ft': ['python', 'ipython']})

    " Linting, syntax, autocomplete, semantic highlighting 
    call dein#add('w0rp/ale')
    call dein#add('davidhalter/jedi-vim', 
                \{'on_ft': ['python', 'ipython'],
                \'command': 'UpdateRemotePlugins'})

    " === nvim feature ===
    " if !has('nvim')
    if has('nvim')
        call dein#add('Shougo/context_filetype.vim')
        call dein#add('Shougo/neoinclude.vim')
        call dein#add('Shougo/deoplete.nvim',
                    \{ 'do': ':UpdateRemotePlugins'})
        call dein#add('zchee/deoplete-jedi',
                    \{'on_ft':['python', 'ipython'],
                    \'depends': ['deoplete.nvim', 'jedi-vim'], 
                    \'do': ':UpdateRemotePlugins',
                    \'install': 'git submodule update --init'
                    \})
        " required for ZSH Autocomplete
        call dein#add('mtikekar/nvim-send-to-term')
        call dein#add('deoplete-plugins/deoplete-zsh', {
                    \ 'on_ft':['zsh'],
                    \ 'depends': 'nvim-send-to-term'
                    \ })
        call dein#add('bfredl/nvim-ipy',
                    \{'on_ft':['python', 'ipython']})
        " Tools for repl
        call dein#add('Vigemus/impromptu.nvim')
        " Lua python
        call dein#add('Vigemus/iron.nvim')
    endif

    if has('macunix')
        call dein#add('rizzatti/dash.vim')
    endif

    call dein#add('tmhedberg/SimpylFold')
    call dein#add('itchyny/lightline.vim')
    call dein#add('maximbaz/lightline-ale')

    call dein#add('numirias/semshi',
                \{'do': ':UpdateRemotePlugins'})

    call dein#add('gu-fan/riv.vim')
    call dein#add('mtdl9/vim-log-highlighting')
    call dein#add('jez/vim-superman') " Man pages
    " vim-json fork that has better highlighting and conceal quote
    call dein#add('elzr/vim-json',
                \ {'on_ft': ['json']})
    "call dein#add('saltstack/salt-vim',
    "            \ {'on_ft': ['salt']})
    call dein#add('hashivim/vim-terraform')
    "call dein#add('juliosueiras/vim-terraform-completion',
    "            \ {'on_ft': ['tf', 'tfvars']})

    call dein#add('vim-scripts/applescript.vim',
                \ {'on_ft': ['applescript']})
    call dein#add('ekalinin/Dockerfile.vim',
                \ {'on_ft': ['dockerfile']})
    call dein#add('towolf/vim-helm', {'on_ft': ['helm']})
    call dein#add('kchmck/vim-coffee-script')

    " --- management
    call dein#add('kevinhui/vim-docker-tools')


    " === end Plugins! ===
    call dein#end()
    "if  ! s:is_sudo
    call dein#save_state()
    "endif
    if dein#check_install()
        " Installation check.
        call dein#install()
    endif
endif

filetype plugin indent on
syntax enable

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
" Pallet One Colorscheme CheatSheet
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
function! SemhiOneHighlights()
    hi semshiParameterUnused ctermfg=209 guifg=#e88388
    hi semshiGlobal          ctermfg=214 guifg=#abb2bf cterm=italic gui=italic
    hi semshiImported        ctermfg=214 guifg=#61AFEF cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#87BA66
    hi semshiLocal           ctermfg=117 guifg=#ffafd7
    hi semshiFree            ctermfg=218 guifg=#87BA66
    hi semshiBuiltin         ctermfg=207 guifg=#56b6c2
    hi semshiAttribute       ctermfg=49  guifg=#87BA66
    hi semshiSelf            ctermfg=249 guifg=#353a44
    hi semshiUnresolved      ctermfg=226 guifg=#e5c07b cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#c678dd guibg=#353a44 

    hi semshiErrorSign       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
    hi semshiErrorChar       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
    "sign define semshiError text="窱" texthl=semshiErrorSign
endfunction

autocmd FileType python call SemhiOneHighlights()

let g:riv_python_rst_hl = 1

"hi one_terminal_color_bg9 ctermfg=209 guibg=#e88388
"hi one_terminal_color_bg10 guibg=#a7cc8c
"hi one_terminal_color_bg11 ctermfg=226 guibg=#ebca8d
"hi one_terminal_color_bg12 ctermfg=117 guibg=#72bef2
"hi one_terminal_color_bg13 ctermfg=207 guibg=#d291e4
"hi one_terminal_color_bg14 ctermbg=214 guibg=#65c2cd
"hi one_terminal_color_bg15 guibg=#e3e5e9

if has('gui_running')
    silent! colorscheme one
elseif (has('termguicolors'))
    set termguicolors
    silent! colorscheme one  
    silent! LightlineColorscheme one
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

autocmd VimResized * wincmd =

set background=dark

function! s:normalToggleColor()
    :let &background = ( &background ==? 'dark'? 'light' : 'dark' ) 
endfunction

com! -nargs=0 ToggleColor
            \ call s:normalToggleColor()

map <F3> :ToggleColor<CR>

" Set max line length.
 execute 'set colorcolumn='.linelen
"highlight OverLength ctermbg=red ctermfg=white ctermfg=231 guifg=#e88388
"execute 'match OverLength /\%'.linelen.'v.\+/'

" Change the Pmenu colors so they're more readable.
"guibg=#353a44 
augroup extracolors
    autocmd!
autocmd VimEnter,Colorscheme * hi ALEWarning ctermbg=0 guibg=#282c34 guifg=#ebca8d ctermfg=yellow
autocmd VimEnter,Colorscheme * hi ALEError ctermbg=0 guibg=#282c34 guifg=#e88388 ctermfg=red
autocmd VimEnter,Colorscheme * hi Pmenu ctermbg=black ctermfg=grey guifg=#abb2bf guibg=#353a44 
autocmd VimEnter,ColorScheme * hi PmenuSbar ctermbg=16 guibg=#282c34
autocmd VimEnter,Colorscheme * hi PmenuSel ctermbg=cyan guibg=#abb2bf 
autocmd VimEnter,Colorscheme * hi PmenuThumb  guibg=#353a44 guifg=#ebca8d
autocmd VimEnter,Colorscheme * hi PmenuThumb  guibg=#353a44 guifg=#ebca8d
autocmd VimEnter,Colorscheme * silent! call s:setLightlineColorscheme("one")

augroup END

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

let g:python_highlight_all = 1


"----------------------------------------------
" Plugin: 'nathanaelkane/vim-indent-guides'
"----------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size = 2
let g:indent_guides_start_level = 2

augroup IndentGuide
    " base 00
    autocmd!
    autocmd VimEnter,Colorscheme * hi IndentGuidesOdd ctermbg=6 guibg=#353a44 ctermfg=16 guifg=#353a44 
    autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=4 guifg=#abb2bf ctermfg=16 guifg=#353a44 
    "" Vim
augroup END

" set highlight cursor
augroup CursorLine
    "  au!
    autocmd!
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

" Make Arrow Keys work
imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m

" Adds for IronRepl: PickRepl PickVirtualEnv PickIPython
"if !empty(glob('$HOME/.config/nvim/iron.plugin.lua')) 
"    silent! luafile $HOME/.config/nvim/iron.plugin.lua
"endif

" === fold settings ==

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

" === Maps
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
" Plugin: 'ack.vim'
"----------------------------------------------
if executable('ag')
    " vimgrep not supported with dispatch
    let g:ack_use_dispatch=0
    let g:ackprg = 'ag --vimgrep'
endif


"----------------------------------------------
" Plugin: 'fzf.vim'
"----------------------------------------------

" Syntax highlight preview
if executable('highlight')
    let g:fzf_preview_highlighter = 'highlight -O xterm256 --line-number --style rdark --force'
endif

" Files with bat previewer
if executable('bat')
    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat -p --color always {}']}, <bang>0)
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


"---------------------------------------------
" Plugin'tpope/vim-markdown'
"----------------------------------------------
let g:markdown_fenced_languages = [
            \ 'vim',
            \ 'help',
            \ 'html',
            \ 'css',
            \ 'coffee',
            \ 'scss',
            \ 'sql',
            \ 'javascript',
            \ 'terraform',
            \ 'tf=terraform',
            \ 'go',
            \ 'python',
            \ 'bash=sh',
            \ 'c',
            \ 'ruby',
            \ 'zsh',
            \ 'yaml',
            \ "yml=yaml",
            \ 'json'
            \ ]


"----------------------------------------------
" Plugin: 'SidOfc/mkdx'
"----------------------------------------------

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
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val !=#:w ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
                \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
                \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>

let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', '-', 'x'] } }



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
    autocmd FileType * exe 'UltiSnipsAddFiletypes ' . &filetype
augroup  END

" --------------------
" Plugin: SkyLeach/pudb.vim
" --------------------
if has('nvim')
endif
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

if executable('javascript-typescript-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'javascript-typescript-server',
                \ 'cmd': {server_info->['javascript-typescript-server']},
                \ 'whitelist': ['javascript', 'javascriptjsx', 'jsx']
                \ })
else
    echomsg "pyls is not available"
" \ 'whitelist': ['javascript', 'javascriptjsx']
endif
if executable('vim-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'vim-language-server',
                \ 'cmd': {server_info->['vim-language-server']},
                \ 'whitelist': ['vim',]
                \ })
else
    echoerr "vim-language-server is not available"
endif
if executable('pyls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python', 'ipython'],
                \ })
else
    echomsg "pyls is not available"
endif

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

augroup vim_blacklist_blacklist
    autocmd!
    autocmd FileType * call s:ale_settings() | call s:SetupJedi()
    exec 'autocmd FileType '.join(g:lightline_blacklist,",") .'silent! ALEDisable'
augroup END

function! s:ale_settings()
    "set omnifunc=ale#completion#OmniFunc
    set completeopt-=preview
    set completeopt+=noselect
    set completeopt+=noinsert
    nmap <silent> gd :ALEGoToDefinitionInTab<CR> " because I prefer tabs
    nmap <silent> gr :ALEFindReferences<CR>
    nmap ]v :ALENextWrap<CR>
    nmap [v :ALEPreviousWrap<CR>
    nmap ]V :ALELast
    nmap [A :ALEFirst
    nmap K :ALEHover<CR>
    nmap <F8> <Plug>(ale_fix)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endfunction


" use tab
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    if exists('*coc#refresh')
    call coc#refresh()
    endif
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><ESC><ESC> pumvisible() ? "\<C-p>" : "\<C-h>"
autocmd CursorHold * if exists('*CocActionAsync') | silent call CocActionAsync('highlight') | endif
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
" refresh on backspace
" inoremap <silent><expr> <TAB> pumvisible() ? : <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

" Control-0
inoremap <silent><c-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><c-k> <C-R>=OmniPopup('k')<CR>


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
"" refresh on backspace
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------


let g:lightline#ale#indicator_checking = ''
let g:lightline#ale#indicator_warnings = ''
let g:lightline#ale#indicator_errors = ''
let g:lightline#ale#indicator_ok = ''

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

let g:lightline = {
            \ 'inactive': {
            \   'left': [ [ 'pyenv_active', 'pyenv' ],
            \             [ 'fugitive', 'filename' ],
            \           ],
            \   'right': [ 
            \             [ 'readonly', 'lineinfo', 'linecount' ],
            \             [ 'filetype', 'fileformatl' ],
            \            ]
            \ },
            \ 'active': {
            \   'left': [ [ 'mode', 'paste', ],
            \             [ 'pyenv_active', 'pyenv', ],
            \             [ 'fugitive', 'filename', 'method', ],
            \           ],
            \   'right': [ 
            \             [ 'readonly', 'percentwin', 'lineinfo',  'linecount', ],
            \             [ 'filetype', 'fileformat', ], 
            \             [ 'spell', ], [ 'linter_checking', 'linter_errors',
            \                'linter_warnings', 'linter_ok' ],
            \            ]
            \ },
            \ 'component_expand' : {
            \  'linter_checking': 'g:lightline#ale#checking',
            \  'linter_warnings': 'g:lightline#ale#warnings',
            \  'linter_errors': 'g:lightline#ale#errors',
            \  'linter_ok': 'g:lightline#ale#ok',
            \  'gitbranch': 'fugitive#head',
            \ },
            \ 'component': {
            \   'linecount': '%{winwidth(0) < getbufvar("b:", "small_threshold", g:small_threshold)?"":line("$")}',
            \   'lineinfo': '%4{winwidth(0) < getbufvar("b:", "small_threshold", g:small_threshold)?"":(&fenc==#"")?"":(winwidth(0) <= getbufvar("b:", "large_threshold", g:large_threshold)||len(col("."))>1000)?"C".col("."):"C".col(".").":"."L".line(".")}',
            \   'close': '%9999X%{g:os_spec_string}',
            \   'spell': '%{winwidth(0) <= getbufvar("b:", "small_threshold", g:small_threshold)?"":&fenc==#""?"":&spell?"":"暈"}%{winwidth(0) <= getbufvar("b:", "large_threshold", g:large_threshold)?"":&spelllang}',
            \   'modified': '%{&modified?"﯂":&modifiable?"":""}',
            \   'readonly': '%{index(g:lightline_blacklist,&filetype)==-1&&(&fenc==#"")?"":(&readonly)?"":""}',
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
            \     'pyenv': '(&filetype=="python"&&exists("pyenv#pyenv#is_enabled")&&1==pyenv#pyenv#is_enabled()&&winwidth(0)>getbufvar("b:", "small_threshold", g:small_threshold))',
            \     'pyenv_active': '(&filetype=="python"&&exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated())',
            \     'method': '(index(g:lightline_blacklist,&filetype)!=-1&&winwidth(0)>=getbufvar("b:", "medium_threshold", g:medium_threshold))',
            \ },
            \ 'component_type': {
            \     'linter_checking': 'left',
            \     'linter_warnings': 'warning',
            \     'linter_errors': 'error',
            \     'linter_ok': 'left',
            \     'banner': 'tabsel',
            \ },
            \ 'component_function': {
            \     'mode': 'LightlineMode',
            \     'filetype': 'LightlineFiletype',
            \     'filename': 'LightlineFilename',
            \     'fileformat': 'LightlineFileFormat',
            \     'method': 'NearestMethodOrFunction',
            \     'fugitive': 'LightlineFugitive',
            \     'paste': 'LightlinePaste',
            \     'pyenv_active': 'LightlinePyEnv',
            \     'pyenv': 'LightlinePyEnvName',
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

let g:small_threshold=51
let g:medium_threshold=75
let g:large_threshold=116

function! LightlineFilename()
    let l:longname=expand('%')
    let l:shortname=expand('%:t')
    let l:l = len(l:longname)
    if winwidth(0) > g:large_threshold + l:l
        let l:shortname=l:longname
    endif
    let l:l = len(l:shortname) + 19
    " 16 = (max length of fugitive) + (~len of seperator)
    let b:small_theshold = g:small_threshold + l:l
    let b:medium_theshold = g:medium_threshold + l:l
    let b:large_theshold = g:large_threshold + l:l
    return l:shortname ==# '__Tagbar__' ? 'Tagbar':
                \ l:shortname ==# '__vista__' ? 'Vista':
                \ l:shortname ==# '__doc__' ? '龎':
                \ l:shortname =~# 'NERDTree' ? '' :
                \ &filetype ==# 'vimfiler' ? 'VimFiler' :
                \ &filetype ==# 'vimshell' ? 'VimShell' : 
                \ l:shortname
endfunction

function! LightlinePyEnv ()
    let l:small_threshold = getbufvar("small_threshold", g:small_threshold)
    return winwidth(0) > l:small_threshold ? WebDevIconsGetFileTypeSymbol('__init__.py',0) : ""
endfunction

function! LightlinePyEnvName ()

    "echo pyenv#info#format('ex: %ev ix: %iv Sel: %sv') 
    let l:env = pyenv#pyenv#get_activated_env()
    let l:small_threshold = getbufvar("small_threshold", g:small_threshold)
    let l:medium_threshold = getbufvar("b:", " medium_threshold", g:medium_threshold)
    let l:large_threshold = getbufvar("b:", "large_threshold", g:large_threshold)
    " Show selected env and version
    if pyenv#info#format('%sv') !=# l:env && winwidth(0) > l:large_threshold
        return l:env
    elseif winwidth(0) < l:small_threshold
        return ""
    else
        return winwidth(0) < l:medium_threshold  ? pyenv#info#preset('short'): pyenv#info#preset('long')
    endif
endfunction 


function! LightlinePaste ()
    let l:small_threshold = getbufvar("b:", "small_threshold", g:small_threshold)
    if index(g:lightline_blacklist,&filetype)==-1
        return (&paste) && winwidth(0) > l:small_threshold ? "" : ""
    endif
    return ''
endfunction

function! LightlineMode()
    let l:mode=lightline#mode()
    let l:newmode = (l:mode ==? 'INSERT' ? "" :
                \ l:mode ==? 'NORMAL' ? "" :
                \ l:mode ==? 'COMMAND' ? "" :
                \ l:mode ==? 'VISUAL' ? "﯎" :
                \ l:mode =~? '^V' ? "" :
                \ l:mode)
    return l:newmode 
endfunction

function! LightlineFugitive()
    let l:medium_threshold = getbufvar("b:", "medium_threshold", g:medium_threshold)
    if index(g:lightline_blacklist,&filetype)!=-1 || winwidth(0) <  l:medium_threshold || !exists('*fugitive#head')
        return ""
    endif 
    let l:branch = fugitive#head()
    if branch ==#""
        return ""
    elseif len(branch) < 36
        return branch
    else
        "only show 16 characters if it's a hash
        return branch[:15] . ' .. ' . branch[(len(branch)-15):]
    endif 
endfunction

function! NearestMethodOrFunction() abort
    let l:medium_threshold = getbufvar("b:", "medium_threshold", g:medium_threshold)
    if index(g:lightline_blacklist,&filetype)==-1 && winwidth(0) >= l:medium_threshold
        return get(b:, 'vista_nearest_method_or_function', '')
    endif
    return ''
endfunction

function! LightlineFiletype()
    let l:wide = winwidth(0)
    let l:large_threshold = getbufvar("b:", "large_threshold", g:large_threshold)
    let l:medium_threshold = getbufvar("b:", "medium_threshold", g:medium_threshold)
    if index(g:lightline_blacklist,&filetype)==-1 && exists('*WebDevIconsGetFileTypeSymbol') && 
                \ &fenc!=#''
        let l:symbol=WebDevIconsGetFileTypeSymbol()
        let new_ft=(strlen(&filetype) ? l:symbol . ' ' . &filetype  : '')
        return l:wide > l:large_threshold ? new_ft : l:symbol
    endif
    return ''
endfunction

function! LightlineFileFormat()
    if index(g:lightline_blacklist,&filetype)==-1 
        let l:small_threshold = getbufvar("b:", "small_threshold", g:small_threshold)
        let l:medium_threshold = getbufvar("b:", "medium_threshold", g:medium_threshold)
        let l:large_threshold = getbufvar("b:", "large_threshold", g:large_threshold)
        let l:symbol=WebDevIconsGetFileFormatSymbol()
        let l:wide = winwidth(0)
        return l:wide <= l:small_threshold ? "" : 
                    \ l:wide <= l:large_threshold ? symbol : symbol . ' ' . &fileformat
    endif
    return ''
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
" ref: https://github.com/inkarkat/vim-StatusLineHighlight/blob/master/plugin/StatusLineHighlight.vim
function! LightlineTabname(n) abort
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let fname = expand('#'.buflist[winnr - 1].':t')
    return fname =~? '__Tagbar__' ? 'Tagbar' :
                \  fname =~? '__Vista__' ? 'Vista' :
                \ fname ==# '__doc__' ? '龎':
                \ fname =~? 'NERD_tree' ? 'NERDTree' : 
                \ ('' !=? fname ? fname : '﬒')
endfunction
fun! s:setLightlineColorscheme(name)
    let g:lightline.colorscheme = a:name
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    let l:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
    " inject center bar blank into pallete (an interesting hack)
    let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    "let s:palette.inactive.middle = s:palette.normal.middle
    let l:palette.tabline.middle = l:palette.normal.middle
endfun


fun! s:lightlineColorschemes(...)
    return map(
                \ globpath(&runtimepath,'autoload/lightline/colorscheme/*.vim',1,1),
                \ 'fnamemodify(v:val,":t:r")')
endfun
com! -nargs=1 -complete=customlist,s:lightlineColorschemes LightlineColorscheme
            \ call s:setLightlineColorscheme(<q-args>)

function! s:ipython_kernels()
    l:kernels_available=substitute(system('ipython kernelspec list \| awk "/python3/{print \$2}"'), '\n', '', 'g')
endfun
com! -nargs=1 -complete=customlist,s:ipython_kernels FileType python 
            \ call s:ipython_kernels


function! s:LightLineRefresh()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

function! s:LightLineUpdateColor()
    call s:LightLineRefresh()
    let s:palette = g:lightline#colorscheme#{g:lightline#.colorscheme}#palette
    " inject center bar blank into pallete (an interesting hack)
    let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    "let s:palette.inactive.middle = s:palette.normal.middle
    let s:palette.tabline.middle = s:palette.normal.middle
endfunction

com! -nargs=0 ToggleColor
            \ call s:LightLineUpdateColor()
com! -nargs=0 LightLineRefresh
            \ call s:LightLineRefresh()

" --------------------
" Plugin: ncm2/float-preview.nvim
" --------------------
function! DisableExtras()
  call nvim_win_set_option(g:float_preview#win, 'number', v:true)
  call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:true)
  call nvim_win_set_option(g:float_preview#win, 'cursorline', v:true)
endfunction
let g:float_preview#auto_close = 0

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
if exists('$TMUX')
    augroup TMUX_TITLE
        autocmd!
        let g:tmux_window_name=system('tmux display-message -p "\#W"')
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name)
        autocmd WinEnter,TabEnter,BufWritePost * call system("tmux rename-window '" . expand('%:t') . "'")
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name)
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
        autocmd!
        autocmd BufEnter * call system("tmux rename-window '" . tabpagenr() . ' ' . LightlineTabname(tabpagenr()) . ' ' . LightlineTabmodified(tabpagenr()) . "'")
        autocmd VimLeave * call system('tmux setw automatic-rename")
    augroup END
endif


"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggleVCS<cr>

let NERDTreeShowBookmarks=1
" Allow NERDTree to change session root.
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0

" Show hidden files by default.
let NERDTreeShowHidden=1
let NERDTreeIgnore=[
            \'\.pyc',
            \'\~$',
            \'\.swo$',
            \'\.swp$',
            \'\.git',
            \'\.hg',
            \'\.svn',
            \'\.bzr'
            \]
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
    autocmd!
    autocmd bufenter * if (winnr('$') == 1 &&
                \ (( exists('b:NERDTreeType') && b:NERDTreeType == 'primary') || 
                \ (&buftype ==# 'quickfix'))) | q | endif
augroup END

let g:NERDTreeIndicatorMapCustom = {
            \ 'Modified'  : '✹',
            \ 'Staged'    : '✚',
            \ 'Untracked' : '﯏',
            \ 'Renamed'   : '➜',
            \ 'Unmerged'  : '',
            \ 'Deleted'   : '✖',
            \ 'Dirty'     : '✗',
            \ 'Clean'     : '✔︎',
            \ 'Ignored'   : '☒',
            \ 'Unknown'   : '?'
            \ }

" Show hidden files by default.
let NERDTreeShowHidden = 0

let NERDTreeShowBookmarks=1
" Allow NERDTree to change session root.
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=0

let g:webdevicons_enable_nerdtree = 1
" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:webdevicons_conceal_nerdtree_brackets = 1


" --------------------
" Plug 'bfredl/nvim-ipy'
" --------------------
let g:ipy_perform_mappings=0
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)%(\ -\ %{g:ipy_status}%)
nmap <silent> <c-s> <Plug>(IPy-Run)
vmap <silent> <c-s> <Plug>(IPy-Run)
nmap <silent> <c-}> <Plug>(IPy-RunCell)
nmap <silent> <leader> <c-}> <Plug>(IPy-RunAll)
map <silent> <leader> <c-c> <Plug>(IPy-Interrupt)
imap <c-f> <Plug>(IPy-Complete)
map <silent> <leader>? <Plug>(IPy-WordObjInfo)
let g:ipy_celldef = '^##'
let g:ipy_shortprompt=1


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
function! RemoveQuickFixItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . 'cfirst'
    :copen
endfunction
command! RemoveQFItem -nargs=0 call RemoveQuickFixItem()
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

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

" You will have bad experience for diagnostic messages when it's default 4000.
" Write diag to disk every 2.5 seconds
set updatetime=2500

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" ighlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
" let g:lsp_highlight_references_enabled = 1


" plugin: Vista.vim
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista_fzf_preview = ['right:50%']
let g:vista_executive_for = {
            \ 'vim': 'ale',
            \ }
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
"let g:vista_default_executive = 'ctags'
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
            \   "function": "\uf794",
            \   "variable": "\uf71b",
            \   "default": "",
            \  }

function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
                \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
                \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')


" --------------------
" Plugin: liuchengxu/vista.vim
" --------------------
" By default vista.vim never run if you don't call it explicitly.
" show the nearest function in your statusline automatically,
augroup VistaHooks
autocmd!
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
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


function! GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    let parts = split(info.location, ':')
    call add(list, {
      \"key": key,
      \"path": parts[0],
      \"linenr": parts[1],
      \"description": info.description,
      \})
  endfor
  return list
endfunction
command! UltiSnipsList echo GetAllSnippets()

function! GetFileAlternate()
if exists('g:loaded_projectionist')
    echo get(filter(g:projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')
  endif
  echo "None"
endfunction
command! FileAlternate call GetFileAlternate()


function! s:is_projectionist_testfile(file) abort
    if exists('g:loaded_projectionist')  && g:loaded_projectionist
        for [root, value] in g:projectionist#query('type', {'file': fnamemodify(a:file, ':p')})
            if value =~? '^\(test[:]\+\)\?pyunit$'
                return root . ':' . value
            else
                echoerr 'Value(' . value . ') in file(' . a:file . ') is not [test:]pyunit'
            endif
        endfor
    endif
endfunction
command! -nargs=0 ShowTestFile echo s:is_projectionist_testfile(expand('%:p'))
" vmap <silent> <Leader>qs :call Quote("'")<CR>
vmap <silent> <Leader>qd :call Quote('"')<CR>
function! Quote(quote)
  let save = @"
  silent normal gvy
  let @" = a:quote . @" . a:quote
  silent normal gvp
  let @" = save
endfunction
nnoremap <Leader>" ciw"<C-r>""<Esc>
vnoremap <Leader>" c"<C-r>""<Esc>

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" { :set sw=2 ts=2 et }
