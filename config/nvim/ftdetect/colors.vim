
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
"hi one_terminal_color_fg2 ctermfg=49 guifg=#a7cc8c #87BA66 
"hi one_terminal_color_fg3 ctermfg=226 guifg=#ebca8d
"hi one_terminal_color_fg4 ctermfg=117 guifg=#72bef2
"hi one_terminal_color_fg5 ctermfg=207 guifg=#d291e4
"hi one_terminal_color_fg6 ctermfg=214 guifg=#65c2cd
"hi one_terminal_color_fg7 ctermfg=231 guifg=#e3e5e9
"
"hi one_terminal_color_fg8 ctermfg=231 guifg=#353a44
"hi one_terminal_color_fg9 ctermfg=249 guifg=#abb2bf
"hi one_terminal_color_bg9 ctermfg=209 guibg=#ffafd7 #e88388
"hi one_terminal_color_bg10 guibg=#a7cc8c
"hi one_terminal_color_bg11 ctermfg=226 guibg=#ebca8d
"hi one_terminal_color_bg12 ctermfg=117 guibg=#72bef2 #61AFEF 
"hi one_terminal_color_bg13 ctermfg=207 guibg=#d291e4 =#c678dd
"hi one_terminal_color_bg14 ctermbg=214 guibg=#65c2cd #56b6c2
"hi one_terminal_color_bg15 guibg=#e3e5e9


function! SemhiOneHighlights()
    hi semshiGlobal          ctermfg=249 guifg=#abb2bf cterm=bold gui=bold
    hi semshiImported        ctermfg=117 guifg=#72bef2 gui=italic 
    hi semshiParameter       ctermfg=249 guifg=#abb2bf gui=italic cterm=italic
    hi semshiParameterUnused ctermfg=226 guifg=#ebca8d gui=italic cterm=italic
    hi semshiLocal           ctermfg=249 guifg=#abb2bf
    hi semshiFree            ctermfg=49 guifg=#87BA66 cterm=bold gui=bold
    hi semshiBuiltin         ctermfg=209 guifg=#d291e4 cterm=italic gui=italic
    hi semshiAttribute       ctermfg=214  guifg=#65c2cd
    hi semshiSelf            ctermbg=NONE ctermfg=214 guifg=#65c2cd cterm=NONE gui=NONE
    hi semshiUnresolved      ctermfg=207 cterm=bold gui=undercurl guisp=#e88388 guifg=#ebca8d 
    hi semshiSelected        ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE gui=underline cterm=underline guisp=#d291e4 

    hi semshiErrorSign       ctermfg=207 guifg=#e3e5e9 gui=inverse cterm=inverse
    hi semshiErrorChar       ctermfg=207 ctermbg=NONE cterm=standout guibg=#e88388 guifg=#e3e5e9 gui=standout

    sign define semshiError text=窱 texthl=semshiErrorSign
endfunction


let g:riv_python_rst_hl = 1

" highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
" let g:lsp_highlight_references_enabled = 1

augroup LintingHighlights
    autocmd!
    autocmd FileType python call SemhiOneHighlights()
    autocmd VimEnter,Colorscheme * hi ALEWarning ctermbg=0 guibg=#282c34 guifg=#ebca8d ctermfg=227
    autocmd VimEnter,Colorscheme * hi ALEError ctermbg=0 guibg=#282c34 guifg=#e88388 ctermfg=209
    autocmd VimEnter,Colorscheme * hi Pmenu ctermbg=black ctermfg=grey guifg=#abb2bf guibg=#353a44 
    autocmd VimEnter,ColorScheme * hi PmenuSbar ctermbg=16 guibg=#282c34
    autocmd VimEnter,Colorscheme * hi PmenuSel guifg=#d291e4 guibg=NONE ctermbg=NONE ctermfg=13 cterm=standout gui=standout
    autocmd VimEnter,Colorscheme * hi PmenuThumb  guibg=#353a44 guifg=#ebca8d ctermbg=NONE ctermfg=227
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


