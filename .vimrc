syntax on
set ruler
set ts=4 sts=4 sw=4 et
set termencoding=utf8
set encoding=utf8
let c_warn_trigraph = 1
set viminfo='100,<50,s10,h
set wildignore+=*/node_modules/*,*/bower_components/*

command! Ctags :!ctags -R --exclude=*.min.* --exclude=*-min.* --c++-kinds=+p --fields=+iaS --extra=+q .

cmap w!! w !sudo tee % >/dev/null

:inoremap <lt>/ </<C-X><C-O>

" bash-like tab completion
set wildmode=longest,list

" {{{ moving between windows
nmap <silent> <M-Up> :wincmd k<CR>
nmap <silent> <M-Down> :wincmd j<CR>
nmap <silent> <M-Left> :wincmd h<CR>
nmap <silent> <M-Right> :wincmd l<CR>
" }}}

" {{{ persistent undo
try
  set undodir=~/.vim/undo
  set undofile
catch
endtry
" }}}

" {{{ Vundle
" required for Vundle
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'

Plugin 'ack.vim'
Plugin 'ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'mhinz/vim-signify'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-endwise'

call vundle#end()
filetype plugin indent on
" }}}

" {{{ colors
if $VIM_SOLARIZED == 1
  set t_Co=16
  set background=light
  let g:solarized_underline = 0
  colorscheme solarized
  let g:airline_theme = 'solarized'
else
  set t_Co=256
  colorscheme jellybeans
  hi link xmlEndTag Function
  let g:airline_theme = 'bubblegum'
endif
" }}}

" {{{ vim-airline
set laststatus=2

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = ''
let g:airline_right_sep = '«'
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" }}}

" {{{ autocmd vim
au FileType vim setl et ts=2 sts=2 sw=2 foldmethod=marker

aug AutoloadVimrc
  au!
  au BufWritePost .vimrc source $MYVIMRC|set ft=vim
  au BufWritePost .vimrc runtime! plugins/**/*.vim
aug END
" }}}
