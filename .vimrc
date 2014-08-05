" vim: et ts=2 sts=2 sw=2 spelllang= :
syntax on
set ruler
set ts=4 sts=4 sw=4 et
set termencoding=utf8
set encoding=utf8
"set spell spelllang=en,ru
set modeline
set modelines=65000
let c_warn_trigraph = 1

set viminfo='100,<50,s10,h

set wildignore+=*/node_modules/*,*/bower_components/*

map <C-S-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

set t_Co=256

"let g:airline_powerline_fonts=1

" moving between windows
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>


" persistent undo
try
  set undodir=~/.vim/undo
  set undofile
catch
endtry


" required for Vundle
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'ack.vim'
Plugin 'ctrlp.vim'
Plugin 'bling/vim-airline'

call vundle#end()
filetype plugin indent on


" vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1
