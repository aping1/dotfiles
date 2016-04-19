set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Bundle 'altercation/vim-colors-solarized'  
Plugin 'vim-scripts/taglist-plus'
Plugin 'vim-scripts/Trinity'
Plugin 'tmhedberg/SimpylFold'

Plugin 'bling/vim-airline'
call vundle#end()            " required
filetype plugin indent on    " required

set rtp+=/Users/awampler/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim
 
" These lines setup the environment to show graphics and colors correctly.
set nocompatible
set t_Co=256
 
" Something about gui
let g:minBufExplForceSyntaxEnable = 1
if ! has('gui_running')
set ttimeoutlen=10
   augroup FastEscape
      autocmd!
      au InsertEnter * set timeoutlen=0
      au InsertLeave * set timeoutlen=1000
   augroup END
endif
 
set laststatus=2 " Always display the statusline in all windows
set guifont=Sauce\ Code\ for\ Powerline:h14 " Font
" set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" Some settings to enable the theme:
set number        " Show line numbers
syntax enable     " Use syntax highlighting
set backspace=indent,eol,start
set background=dark
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
"let g:solarized_termcolors=16
colorscheme solarized
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
