
if exists("g:loaded_custom_tmux")
    finish
endif
let g:loaded_custom_tmux= 1

" -----
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if empty($TMUX) && has('nvim') 
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
endif

if exists('$TMUX')
    augroup TMUX_TITLE
        autocmd!
        let g:tmux_window_name=system('tmux display-message -p "\#W"')
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name)
        autocmd WinEnter,TabEnter,BufWritePost * call system("tmux rename-window '" . expand('%:t') . "'")
        autocmd VimLeavePre * call system('tmux rename-window ' . g:tmux_window_name)
    augroup END
    " tmux will send xterm-style keys when its xterm-keys option is on
    if &term =~? '^screen'
        execute 'set <xUp>=\e[1;*A'
        execute 'set <xDown>=\e[1;*B'
        execute 'set <xRight>=\e[1;*C'
        execute 'set <xLeft>=\e[1;*D'
    endif

    let g:tmux_navigator_save_on_switch = 1

    " Move between splits with ctrl+h,j,k,l
    nnoremap <silent> <leader><c-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <leader><c-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <leader><c-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <leader><c-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <leader><c-\> :TmuxNavigatePrevious<cr>
endif
