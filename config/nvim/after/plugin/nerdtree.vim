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

if exists('g:webdevicons_enable_nerdtree')
    let g:webdevicons_enable_nerdtree = 1
    " Force extra padding in NERDTree so that the filetype icons line up vertically
    let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
    let g:webdevicons_conceal_nerdtree_brackets = 1
endif
