if exists("g:loaded_custom_lightline")
    finish
endif
let g:loaded_custom_lightline=1

let g:lightline#ale#indicator_checking = ''
let g:lightline#ale#indicator_warnings = ''
let g:lightline#ale#indicator_errors = ''
let g:lightline#ale#indicator_ok = ''

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

