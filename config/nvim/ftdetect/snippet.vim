" autoload/snippet.vim

function! s:try_insert(skel)
  execute "normal! i_" . a:skel . "\<C-r>=UltiSnips#ExpandSnippet()\<CR>"

  if g:ulti_expand_res == 0
    silent! undo
  endif

  return g:ulti_expand_res
endfunction

function! snippet#InsertSkeleton() abort
  let filename = expand('%')

  " Abort on non-empty buffer or extant file
  if !(line('$') == 1 && getline('$') == '') || filereadable(filename)
    return
  endif

  if !empty('b:projectionist')
    " Loop through projections with 'skeleton' key and try each one until the
    " snippet expands
    for [root, value] in projectionist#query('skeleton')
      if s:try_insert(value)
        return
      endif
    endfor
  endif

  " Try generic _skel template as last resort
  call s:try_insert('skel')
endfunction

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

