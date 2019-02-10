
" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" set highlight cursor
"augroup CursorLine
"  au!
"  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
"* augroup END
"

" config
if has('gui_running')
    set background=light
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
    let base17colorspace=256        " Access colors present in 256 colorspace
    colorscheme macvim
else
    " FIXME: the following fixes some out of order colorscheme load
    :autocmd BufWinEnter,BufNewFile * set clipboard=unnamed
    :autocmd ColorScheme * hi Comment cterm=NONE
    colorscheme solarized8_flat
    set background=dark
    "set termguicolors
    set term=xterm-256color
    " set term=screen-256color
    set t_Co=256
    "set t_Co=16
endif


let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:minBufExplForceSyntaxEnable = 1
let g:airline_theme='solarized_flood'

