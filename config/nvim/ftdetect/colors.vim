
if exists("g:loaded_custom_ft_colors")
    finish
endif
let g:loaded_custom_ft_colors = 1

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
" Pallet One Colorscheme CheatSheet
"hi one_terminal_color_fg0 guifg=#353a44
"hi one_terminal_color_fg1 ctermfg=209 guifg=#e88388
"hi one_terminal_color_fg2 ctermfg=49 guifg=#a7cc8c 
"hi one_terminal_color_fg3 ctermfg=226 guifg=#ebca8d
"hi one_terminal_color_fg4 ctermfg=117 guifg=#72bef2
"hi one_terminal_color_fg5 ctermfg=207 guifg=#d291e4
"hi one_terminal_color_fg6 ctermfg=214 guifg=#65c2cd
"hi one_terminal_color_fg7 ctermfg=231 guifg=#e3e5e9
"hi one_terminal_color_fg8 ctermfg=231 guifg=#353a44
"hi one_terminal_color_fg9 ctermfg=249 guifg=#abb2bf
"hi one_terminal_color_bg9 ctermfg=209 guibg=#e88388
"hi one_terminal_color_bg10 guibg=#a7cc8c
"hi one_terminal_color_bg11 ctermfg=226 guibg=#ebca8d
"hi one_terminal_color_bg12 ctermfg=117 guibg=#72bef2
"hi one_terminal_color_bg13 ctermfg=207 guibg=#d291e4
"hi one_terminal_color_bg14 ctermbg=214 guibg=#65c2cd
"hi one_terminal_color_bg15 guibg=#e3e5e9


function! SemhiOneHighlights()
    hi semshiParameterUnused ctermfg=209 guifg=#e88388
    hi semshiGlobal          ctermfg=214 guifg=#abb2bf cterm=italic gui=italic
    hi semshiImported        ctermfg=214 guifg=#61AFEF cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#87BA66
    hi semshiLocal           ctermfg=117 guifg=#ffafd7
    hi semshiFree            ctermfg=218 guifg=#87BA66
    hi semshiBuiltin         ctermfg=207 guifg=#56b6c2
    hi semshiAttribute       ctermfg=49  guifg=#87BA66
    hi semshiSelf            ctermfg=249 guifg=#353a44
    hi semshiUnresolved      ctermfg=226 guifg=#e5c07b cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#c678dd guibg=#353a44 

    hi semshiErrorSign       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
    hi semshiErrorChar       ctermfg=231 guifg=#353a44 ctermbg=160 guibg=#e88388
    "sign define semshiError text="窱" texthl=semshiErrorSign
endfunction

autocmd FileType python call SemhiOneHighlights()

let g:riv_python_rst_hl = 1

" highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
" let g:lsp_highlight_references_enabled = 1

augroup LintingHighlights
    autocmd!
    autocmd VimEnter,Colorscheme * hi ALEWarning ctermbg=0 guibg=#282c34 guifg=#ebca8d ctermfg=yellow
    autocmd VimEnter,Colorscheme * hi ALEError ctermbg=0 guibg=#282c34 guifg=#e88388 ctermfg=red
    autocmd VimEnter,Colorscheme * hi Pmenu ctermbg=black ctermfg=grey guifg=#abb2bf guibg=#353a44 
    autocmd VimEnter,ColorScheme * hi PmenuSbar ctermbg=16 guibg=#282c34
    autocmd VimEnter,Colorscheme * hi PmenuSel ctermbg=cyan guibg=#abb2bf 
    autocmd VimEnter,Colorscheme * hi PmenuThumb  guibg=#353a44 guifg=#ebca8d
    autocmd VimEnter,Colorscheme * hi PmenuThumb  guibg=#353a44 guifg=#ebca8d
    autocmd VimEnter,Colorscheme * silent! call s:setLightlineColorscheme("one")
augroup END
augroup IndentGuide
    " base 00
    autocmd!
    autocmd VimEnter,Colorscheme * hi IndentGuidesOdd ctermbg=6 guibg=#353a44 ctermfg=16 guifg=#353a44
    autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=4 guifg=#abb2bf ctermfg=16 guifg=#353a44
    "" Vim
augroup END

" Set max line length.
 execute 'set colorcolumn='.g:linelen
"highlight OverLength ctermbg=red ctermfg=white ctermfg=231 guifg=#e88388
"execute 'match OverLength /\%'.linelen.'v.\+/'
" Change the Pmenu colors so they're more readable.
"guibg=#353a44 
" set highlight cursor
augroup CursorLine
    autocmd!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    "  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
    "  au WinLeave * setlocal nocursorline
augroup END


