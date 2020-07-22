if exists("g:loaded_nerdree_live_preview_mapping")
  finish
endif
let g:loaded_nerdree_live_preview_mapping = 1

function! NERDTreeLivePreview()
  " Get the path of the item under the cursor if possible:
  let current_file = g:NERDTreeFileNode.GetSelected()

  if current_file == {}
    return
  else
    exe 'pedit '.current_file.path.str()
  endif
endfunction
autocmd FileType nerdtree nnoremap <buffer> <up> :call NERDTreeLivePreview()<cr>



function! NERDTreeYankCurrentNode()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
        call setreg('=', n.path.str())
        call setreg('+', n.path.str())
    endif
endfunction

if exists('NERDTreeAddKeyMap')
    call NERDTreeAddKeyMap({
                \ 'key': 'yy',
                \ 'callback': 'NERDTreeYankCurrentNode',
                \ 'quickhelpText': 'put full path of current node into the default register' })
    call NERDTreeAddKeyMap({
        \ 'key':           '<up>',
        \ 'callback':      'NERDTreeLivePreview',
        \ 'quickhelpText': 'preview'
        \ })

endif
