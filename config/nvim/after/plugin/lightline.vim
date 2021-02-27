if exists("g:loaded_custom_after_lightline")
    finish
endif
let g:loaded_custom_after_lightline = 1

let s:base_dir = resolve(expand("<sfile>:p:h"))

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

let g:lightline_blacklist=[
            \"help",
            \"nofile",
            \"nerdtree",
            \"vista", 
            \"qf"
            \]

exec 'autocmd FileType '.join(g:lightline_blacklist,",") .'silent! ALEDisable'

let g:lightline#ale#indicator_checking = ''
let g:lightline#ale#indicator_warnings = 'ﯜ '
let g:lightline#ale#indicator_errors = ' '
let g:lightline#ale#indicator_ok = ''

function! s:LightLineRefresh()
if exists('*g:lightline#init')
    call g:lightline#init()
    call g:lightline#colorscheme()
    call g:lightline#update()
endif
endfunction

function! s:LightLineUpdateColor()
    call s:LightLineRefresh()
    let s:palette = g:lightline#colorscheme#{g:lightline#.colorscheme}#palette
    " inject center bar blank into pallete (an interesting hack)
    let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    let s:palette.inactive.middle = s:palette.normal.middle
    let s:palette.tabline.middle = s:palette.normal.middle
endfunction

com! -nargs=0 ToggleColor
            \ call s:LightLineUpdateColor()
com! -nargs=0 LightLineRefresh
            \ call s:LightLineRefresh()

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

function! s:LoadLightline()
    let g:lightline_jsn = s:base_dir . "/lightline.json"

    if filereadable(g:lightline_jsn)
        echomsg 'Loading Lightline...' .  g:lightline_jsn

        let l:lightlinejson = readfile(g:lighting_jsn)
        let l:lightline = projectionist#json_parse(l:lightlinejson)
        let g:lightline = copy(l:lightline)
    else
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
            \             [ 'spell', ], [ 'linter_checkcount','linter_checking', 'linter_errors',
            \                'linter_warnings', 'linter_ok',  'neomake_status' ],
            \            ]
            \ },
            \ 'component_expand' : {
            \  'linter_checkcount': 'b:ale_linted',
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
            \     'linter_checkcount': '(index(g:lightline_blacklist,&filetype)==-1)',
            \     'fileformat' : '(winwidth(0) > getbufvar("b:", "medium_threshold", g:medium_threshold))',
            \     'linter_counter': '(index(g:lightline_blacklist,&filetype)==-1&&exists("b:ale_linted")&&b:ale_linted>0)',
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
            \     'test_status': '(index(g:lightline_blacklist,&filetype)==-1&&(getbufvar("b:","testing_status",0)!=0)&&(getbufvar("b:","ale_linted",0)!=0))'
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
            \     'test_status': 'LightlineTestStatus'
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
    endif
endfunction

call s:LoadLightline()

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

function! LightlineTestStatus()
    if index(g:lightline_blacklist,&filetype)==-1
        return getbufvar("b:","testing_status",0) . ' ' . getbufvar("b:","ale_linted", "None")
    endif
,
endfunction

function! LightlinePyEnv ()
    let l:small_threshold = getbufvar("small_threshold", g:small_threshold)
    let l:pyenv = exists("pyenv#pyenv#is_activated")&&1==pyenv#pyenv#is_activated() ? "" : ""
    let l:pycon = l:small_threshold && exists('*WebDevIconsGetFileTypeSymbol') ? WebDevIconsGetFileTypeSymbol('__init__.py',0) : ""
    return l:pyenv . l:pycon
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
    return l:newmode  . ' '
endfunction

function! LightlineFugitive()
    let l:medium_threshold = getbufvar("b:", "medium_threshold", g:medium_threshold)
    if index(g:lightline_blacklist,&filetype)!=-1 || winwidth(0) <  l:medium_threshold || !exists('*fugitive#head')
        return ""
    endif 
    let l:branch = fugitive#statusline()
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
        let l:symbol=exists('*WebDevIconsGetFileFormatSymbol') ? WebDevIconsGetFileFormatSymbol() : ""
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
        let l:symbol=exists('*WebDevIconsGetFileFormatSymbol') ? WebDevIconsGetFileFormatSymbol() : ""
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



" --------------------
" Plugin 'neomake/neomake'
" --------------------
" initially empty status
let g:testing_status = ''

" Show message when all tests are passing
function! TestFinished() abort
  let context = g:neomake_hook_context
  if context.jobinfo.exit_code == 0
    call setbufvar("b:", "testing_status", ' ')
  endif
  if context.jobinfo.exit_code >= 1
    call setbufvar("b:", "testing_status", '' . context.jobinfo.exit_code )
  endif
endfunction

" Start test
function! TestStarted() abort
  call setbufvar("b:", "testing_status", '痢')
endfunction

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
    let s:palette.inactive.middle = s:palette.normal.middle
    let s:palette.tabline.middle = s:palette.normal.middle
endfunction

com! -nargs=0 ToggleColor
            \ call s:LightLineUpdateColor()
com! -nargs=0 LightLineRefresh
            \ call s:LightLineRefresh()


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

command! -nargs=+ -complete=command Vcs call Vcs(<q-args>)
function! Vcs(cmd) abort
    let saved = getcwd()
    exe 'cd ' . GetVcsRoot()
    try
        exe a:cmd
    catch
        echohl ErrorMsg | echo v:exception | echohl None
    endtry
    exe 'cd ' . saved
endfunction
function! GetVcsRoot() abort
    let cph = expand('%:p:h', 1)
    if cph =~# '^.\+://' | retu | en
    for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', '.vimprojects']
        let wd = call('find' . (mkr =~# '/$' ? 'dir' : 'file'), [mkr, cph . ';'])
        if !empty(wd) | let &acd = 0 | brea | en
    endfo
    return fnameescape(empty(wd) ? cph : substitute(wd, mkr . '$', '.', ''))
endfunction
