"----------------------------------------------
" Plugin: 'fzf.vim'
"----------------------------------------------

let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_directory_files_command = 'fd -l --hidden --follow --no-messages' 
if exists('g:ackprg')
  let g:fzf_preview_grep_cmd = g:ackprg
endif


"""""""""""""""""
" Fuzzy Finding "
"""""""""""""""""
let g:fzf_colors =
\ { 'fg':      ['fg', 'Pmenu'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['Comment'],
\ 'fg+':     ['fg', 'PmenuSel'],
\ 'bg+':     ['bg', 'PmenuSel'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] }

" Hide status bar while using fzf  
if has('nvim') || has('gui_running')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
endif

" Centered floating window for fzf
if has('nvim')
  let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
else
  let g:fzf_layout = { 'down': '40%' }
endif

" Syntax highlight preview
"if executable('highlight')
"    let g:fzf_preview_highlighter = 'highlight -O xterm256 --line-number --style rdark --force'
"endif
" Files with bat previewer
"if executable('bat')
"    command! -bang -nargs=? -complete=dir Files
"                \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat -p --style snip --color always {}']}, <bang>0)
""endif
