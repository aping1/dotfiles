if exists("g:loaded_custom_commands")
    finish
endif
let g:loaded_custom_commands= 1

function! GetFileAlternate()
if exists('g:loaded_projectionist')
    echo get(filter(projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')
  endif
  echo "None"
endfunction
command! FileAlternate call GetFileAlternate()

function! s:newtest_file(file) abort
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
command! -nargs=0 ShowTestFile echo s:newtest_file(expand('%:p'))

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
function! s:removeQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . 'cfirst'
    :copen
endfunction
command! RemoveQFItem -nargs=0 s:removeQFItem
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

com! -nargs=0 ToggleColor
            \ call s:normalToggleColor()

map <F3> :ToggleColor<CR>




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

function! Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

function! GetFileAlternate()
if exists('g:loaded_projectionist')
    echo get(filter(g:projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')
  endif
  echo "None"
endfunction
command! FileAlternate call GetFileAlternate()

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


" vmap <silent> <Leader>qs :call Quote("'")<CR>
vmap <silent> <Leader>qd :call Quote('"')<CR>

function! Quote(quote)
  let save = @"
  silent normal gvy
  let @" = a:quote . @" . a:quote
  silent normal gvp
  let @" = save
endfunction

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

