if exists('g:loaded_vim_projectionist_global') 
  finish
endif
let g:loaded_vim_projectionist_elixir = 1

let s:base_dir = resolve(expand("<sfile>:p:h"))
let s:proj_jsn = s:base_dir . "/projections.json"

function! s:setProjections()
  let l:json = readfile(s:proj_jsn)
  let l:dict = projectionist#json_parse(l:json)
  call projectionist#append(getcwd(), l:dict)
endfunction

augroup detect_project
  autocmd!
  autocmd User ProjectionistDetect :call s:setProjections()
augroup end

