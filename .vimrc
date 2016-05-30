set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'  
Plugin 'vim-scripts/taglist-plus'
Plugin 'vim-scripts/Trinity'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/vim-json-bundle' " Pathogen friendly file type plugin bundle for json files

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
call vundle#end()            " required
filetype plugin indent on    " required

" Uncomment this to enable powerline
" set rtp+=/Users/awampler/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim
 
" These lines setup the environment to show graphics and colors correctly.
set nocompatible
set t_Co=256
 
" Quickly close in gui mode
if ! has('gui_running')
set ttimeoutlen=10
   augroup FastEscape
      autocmd!
      au InsertEnter * set timeoutlen=0
      au InsertLeave * set timeoutlen=1000
   augroup END
endif
 
" Always display the statusline in all windows
set laststatus=2 
" set font
set guifont=Sauce\ Code\ for\ Powerline:h14 

" Hide the default mode text (e.g. -- INSERT -- below the statusline)
" set noshowmode 

" Show line numbers
set number        
" Use syntax highlighting
syntax enable     

" fix backspace to work like you would expect
set backspace=indent,eol,start

" Color Scheme
colorscheme solarized
set background=dark
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_termcolors=256

" Setup airline
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:minBufExplForceSyntaxEnable = 1
