if exists("g:loaded_custom_functions")
    finish
endif
let g:loaded_custom_functions=1
"autocmd VimEnter * command! -nargs=* Ag call fzf#vim#ag(<q-args>, '--color-path 400 --color-line-number 400', fzf#vim#default_layout)

" REQUIRED FOR LAZYG
" Creates a floating window with a most recent buffer to be used
function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    "set winhl=Normal:MarkdownError,Visual:MarkdownError,CursorLine:MarkdownError
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    autocmd BufWipeout <buffer> exe 'bwipeout '.s:buf
endfunction

function! GetFileAlternate()
if exists('g:loaded_projectionist')
    echo get(filter(g:projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')
  endif
  echo "None"
endfunction

function! UltiSnipsGetAllSnippets()
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

function! Quote(quote)
  let save = @"
  silent normal gvy
  let @" = a:quote . @" . a:quote
  silent normal gvp
  let @" = save
endfunction

function! FzfAgFromSearch()
    " translate vim regular expression to perl regular expression.
    let l:search = substitute(getreg('/'), '\(\\<\|\\>\)', '\\b', 'g')
    call fzf#vim#ag(l:search)
endfunction

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQuickFixItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . 'cfirst'
    :copen
endfunction

function! ProjectionistTestFile(file) abort
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

function! Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

" Commands
com! -nargs=0 ShowTestFile echo s:newtest_file(expand('%:p'))
com! FileAlternate call GetFileAlternate()
com! UltiSnipsList echo UltiSnipsGetAllSnippets()

"com! -nargs=+ -complete=file Ag call FzfAgFromSearch(<q-args>)

com! -nargs=0 ShowTestFile echo ProjectionistTestFile(expand('%:p'))
com! RemoveQFItem -nargs=0 call RemoveQuickFixItem()
com! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

com! -nargs=0 ToggleColor
            \ call s:normalToggleColor()

augroup QUICKFIX
autocmd!
autocmd FileType qf call AdjustWindowHeight(3, 10)
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
augroup END
