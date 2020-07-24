if exists('g:loaded_vim_projectionist_global') 
    finish
endif
let g:loaded_vim_projectionist_custom = 1
let s:base_dir = resolve(expand("<sfile>:p:h"))
let g:projjsn = s:base_dir . "/projections.json"


let g:projectionist_custom#verbose = 0

function! s:ReloadHeuristics()
    let l:projson = readfile(g:projjsn)
    let l:project= projectionist#json_parse(l:projson)
    let g:projectionist_heuristics = l:project
endfunction
call s:ReloadHeuristics()

" Function: lh#path#join(pathparts, {path_separator}) {{{3
" Thanks: https://stackoverflow.com/questions/62458122/suggested-way-to-join-filepaths-in-vim
function! s:pathjoin(pathparts, ...) abort
  let sep
        \ = (a:0) == 0                       ? '/'
        \ : type(a:1)==type(0) && (a:1) == 0 ? '/'
        \ : (a:1) == 1                       ? '\'
        \ : (a:1) =~ 'shellslash\|ssl'       ? (&ssl ? '\' : '/')
        \ :                                    (a:1)
  return join(a:pathparts, sep)
endfunction

function! s:SetProjections()
    if exists('b:projectionist')
        for p in keys(b:projectionist)
            let l:p = projectionist#path(p)
            let l:jfp = s:pathjoin([l:p,'.projectionist.json'])
            try
                let l:json = readfile(l:jfp)
                try
                    let l:dict = projectionist#json_parse(l:json)
                    call projectionist#append(l:p, l:dict)
                catch  
                    echoerr "Failed for " .  l:jfp
                endtry
            catch /^Vim\%((\a\+)\)\=:E484/ "Unable to find the file"
                if g:projectionist_custom#verbose ==# 1
                    echomsg "Failed to load " . v:exception
                endif
            endtry
        endfor
    endif
endfunction

command! LoadProjections call s:SetProjections()
command! ResetProjections call s:ReloadHeuristics() | call s:SetProjections() | call projectionist#activate()

augroup detect_project
    autocmd!
    autocmd User ProjectionistDetect call s:SetProjections()
augroup end

"augroup detect_project
"  autocmd!
"  " autocmd User ProjectionistActivate call s:activate()
"augroup end


"function! s:activate() abort
"  autocmd!
"    for [root, value] in projectionist#query('wrap')
"    let &l:textwidth = value
"    break
"    endfor
"endfunction
"
