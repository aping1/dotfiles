"----------------------------------------------
" Dein
"----------------------------------------------
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    " :DeinUpgrade command using minimal SpaceVim ui
    " relys on spaceship logging functions
    call dein#add('wsdjeg/dein-ui.vim')

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
        call dein#add('mhinz/vim-startify')
    endtry

    try
        " For more info on TOML and moving plugins...
        " https://github.com/Shougo/dein.vim/blob/aa1da8e43b74c109c49281998eab0e148dc042b2/doc/dein.txt
        let s:toml = '~/.config/nvim/plugins.toml'
        call dein#load_toml(s:toml, {'lazy': 0})
    catch /.*/
        echoerr v:exception
        echomsg 'Error loading ...'
        echomsg 'Caught: ' v:exception
        echoerr 'error ' . s:toml . 'config'
    endtry

    if has('python3')
        call dein#add('puremourning/vimspector',
                \ {'hook_post_update': 'VimspectorInstall --enable-python'}
                \ )
    endif

    " Dynamic resize quickfix window
    call dein#add('blueyed/vim-qf_resize')
    call dein#add('sheerun/vim-polyglot')

    " --- Sesnible defaults ---
    call dein#add('tpope/vim-sensible')
    " ds, cs, and yss
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-repeat')

    call dein#add('stefandtw/quickfix-reflector.vim')
    " --- TMUX Integration ctrl-hjkl % copy/paste
    call dein#add('tmux-plugins/vim-tmux-focus-events')
    call dein#add('roxma/vim-tmux-clipboard')

    " --- Colorscheme ---
    call dein#add('flazz/vim-colorschemes')
    call dein#add('iCyMind/NeoSolarized')
    call dein#add('jacoborus/tender.vim')
    call dein#add('rakr/vim-one')
    call dein#add('joshdick/onedark.vim')

    " === Indent lines ===
    call dein#add('nathanaelkane/vim-indent-guides')
    " Highlight colors
    call dein#add('ap/vim-css-color',
                \ {'on_ft': ['vim']})
    call dein#add('tpope/vim-scriptease')
    " Auto color hex
    call dein#add('lilydjwg/Colorizer')

    " Hide sum and such as unicode 
    call dein#add('ryanoasis/vim-devicons')
    " View unicode sets (not async)
    call dein#add('chrisbra/unicode.vim', {
                \'on_ft': 'vim'
                \})
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
        call dein#add('Shougo/unite-outline')
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

    " zinit manage fzf updates
    set runtimepath+=~/.zsh/zinit/plugins/junegunn---fzf_master

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
    call dein#add('neomake/neomake')

    " -- REPLs
    if has('nvim')
        call dein#add('bfredl/nvim-ipy',
                    \{'on_ft':['python', 'ipython']})
    else
        call dein#add('jupyter-vim/jupyter-vim')
    endif
    " Tools for repl
    call dein#add('Vigemus/impromptu.nvim')
    " Lua framework for quick menus
    call dein#add('Vigemus/iron.nvim')
    call dein#add('jpalardy/vim-slime',
                \{'on_ft':['python', 'ipython']})
    " Snippet engine 
    call dein#add('SirVer/ultisnips',
                \{ 'tag': '1.3'})

    call dein#add('honza/vim-snippets')
    call dein#add('srydell/vim-skeleton')

    " Navigation
    call dein#add('jistr/vim-nerdtree-tabs')
    call dein#add('scrooloose/nerdtree')

    call dein#add('Xuyuanp/nerdtree-git-plugin')

    call dein#add('scrooloose/nerdcommenter')

    call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
    call dein#add('mg979/vim-visual-multi')
    call dein#add('yuttie/comfortable-motion.vim')

    call dein#add('junegunn/fzf.vim')
    call dein#add('dhruvasagar/vim-table-mode')
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

    call dein#add('lambdalisue/vim-pyenv')
    " Python virtuel env
    if executable('pyenv')
        call dein#add('lambdalisue/vim-pyenv')
    else
        call dein#add('plytophogy/vim-virtualenv')
    endif

    " --- Autocomplete
    if has('nvim')
    else
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    " call dein#add('SkyLeach/pudb.vim', {'on_ft': ['python', 'ipython']})

    " Linting, syntax, autocomplete, semantic highlighting 
    call dein#add('w0rp/ale')
    call dein#add('davidhalter/jedi-vim', 
                \{'on_ft': ['python', 'ipython'],
                \'command': 'UpdateRemotePlugins'})

    " === nvim feature ===
    " if !has('nvim')
    if has('nvim')
        call dein#add('Shougo/context_filetype.vim')
        call dein#add('ncm2/float-preview.nvim')
        call dein#add('neoclide/coc.nvim', {
                    \ 'branch': 'release',
                    \ 'build':  'yarn install --frozen-lockfile',
                    \ 'hook_post_source': 'let g:coc_global_extensions = [
                    \"coc-python",
                    \"coc-neco",
                    \"coc-neoinclude",
                    \"coc-html",
                    \"coc-xml",
                    \"coc-java",
                    \"coc-ccls",
                    \"coc-lua",
                    \"coc-sql",
                    \"coc-go",
                    \"coc-css",
                    \"coc-sh",
                    \"coc-neoinclude",
                    \"coc-prettier",
                    \"coc-tsserver",
                    \"coc-docker",
                    \"coc-pairs",
                    \"coc-json",
                    \"coc-imselect",
                    \"coc-highlight",
                    \"coc-git",
                    \"coc-github",
                    \"coc-gitignore",
                    \"coc-emoji",
                    \"coc-lists",
                    \"coc-post",
                    \"coc-stylelint",
                    \"coc-yaml",
                    \"coc-snippets",
                    \"coc-utils"
                    \ ]',
                    \ 'hook_post_update': 'call dein#build("coc.nvim") | call coc#util#install()'
                    \ })
        call dein#add('Maxattax97/coc-ccls', {
                    \ 'branch': 'release',
                    \ 'build':  '''existing=~/.config/coc/extensions/node_modules/coc-ccls/node_modules/ws/lib/extension.js; missing=~/.config/coc/extensions/node_modules/coc-ccls/lib/extension.js; command -v gln && LN=gln; [[ -e "$existing" && ! -e "$missing" ]] && mkdir -p "$(dirname "$missing")" && { ${LN:-ln} -rs "$existing" "$missing" 2>/dev/null || ${LN} -s "$existing" "$missing";}''',
                    \ 'hook_post_update': 'call dein#build("coc-ccls") coc#util#install()'})
        call dein#add('Shougo/deoplete.nvim',
                    \{ 'hook_post_update': 'UpdateRemotePlugins'})
        call dein#add('zchee/deoplete-jedi',
                    \{'on_ft':['python', 'ipython'],
                    \'depends': ['deoplete.nvim', 'jedi-vim'], 
                    \'hook_post_update': 'UpdateRemotePlugins',
                    \'install': 'git submodule update --init'
                    \})
        " required for ZSH Autocomplete
        call dein#add('mtikekar/nvim-send-to-term')
        call dein#add('deoplete-plugins/deoplete-zsh', {
                    \ 'on_ft':['zsh'],
                    \ 'depends': 'nvim-send-to-term'
                    \ })
    endif

    if has('macunix')
        call dein#add('rizzatti/dash.vim')
    endif

    call dein#add('tmhedberg/SimpylFold')
    call dein#add('itchyny/lightline.vim')
    call dein#add('maximbaz/lightline-ale')

    if has('nvim')
    call dein#add('numirias/semshi',
                \{'hook_post_update': 'UpdateRemotePlugins'})
    endif

    call dein#add('gu-fan/riv.vim', {'on_ft': ['rst']})
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
    call dein#add('kchmck/vim-coffee-script', {'on_ft': ['coffee']})

    " --- management
    call dein#add('kevinhui/vim-docker-tools')

    call dein#add('junegunn/goyo.vim')

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
