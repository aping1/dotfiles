"Whitespace setting
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
""""""""""""""""""""""""""""
"""" Format ExtraWhitespace
"""""""""""""""""""""""""""
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight ExtraWhitespace ctermbg=red guibg=red
" Colorize listchars to be black
" Using before the first colorscheme command will ensure that the highlight group gets created and is not cleared by future colorscheme commands
:autocmd ColorScheme * highlight SpecialKey ctermbg=0 ctermfg=232
:autocmd ColorScheme * hi TagbarSignature ctermfg=3 ctermbg=0 cterm=bold
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

:autocmd ColorScheme * hi CursorLine ctermfg=136 ctermbg=0 cterm=NONE
highlight ColorColumn ctermbg=lightblue
call matchadd('ColorColumn', '\%81v', 100)

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/
" Show tabs that are not at the start of a line:
" :match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
" :match ExtraWhitespace /^\t*\zs \+/

" The following pattern will match trailing whitespace, except when typing at 
" the end of a line.
:match ExtraWhitespace /\s\+\%#\@<!$/
" Switch off :match highlighting.
":match

" If you use this alternate pattern, you may want to consider using the 
"*  following autocmd to let the highlighting show up as soon as you leave insert
" mode after entering trailing whitespace:
:autocmd InsertLeave * redraw!
:au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match ExtraWhitespace /\s\+$/
