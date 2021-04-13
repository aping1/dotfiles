if has('nvim')

augroup TERMINAL
" When term starts, auto go into insert mode
autocmd TermOpen * startinsert

" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber
augroup END

function! ToggleTerm(cmd)
    if empty(bufname(a:cmd))
        call CreateCenteredFloatingWindow()
        call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
    else
        bwipeout!
    endif
endfunction

function! OnTermExit(job_id, code, event) dict
    if a:code == 0
        bwipeout!
    endif
endfunction

" Open Project see:
" https://github.com/tmuxinator/tmuxinator"
" https://github.com/camspiers/tmuxinator-fzf-start
function! ToggleProject()
    call ToggleTerm('tmuxinator-fzf-start.sh')
endfunction

function! ToggleScratchTerm()
    call ToggleTerm('bash')
endfunction

function! ToggleLazyGit()
    call ToggleTerm('lazygit')
endfunction

function! ToggleLazyDocker()
    call ToggleTerm('lazydocker')
endfunction

endif
