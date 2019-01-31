syntax on
set ruler
set ts=4 sts=4 sw=4 et
set termencoding=utf8
set encoding=utf8
let c_warn_trigraph = 1
set viminfo='100,<2000,s10,h
set wildignore+=*/node_modules/*,*/bower_components/*
set bs=indent,eol,start
set mouse=n

command! Ctags :!ctags -R --exclude=*.min.* --exclude=*-min.* --exclude=node_modules --c++-kinds=+p --fields=+iaS --extra=+q .

cmap w!! w !sudo tee % >/dev/null

" allows to use <i> key in the cyrillic layout
map ш i

:inoremap <lt>/ </<C-X><C-O>

" bash-like tab completion
set wildmode=longest,list

let g:go_test_timeout="20s"

" {{{ moving between windows
nmap <silent> <M-Up> :wincmd k<CR>
nmap <silent> <M-Down> :wincmd j<CR>
nmap <silent> <M-Left> :wincmd h<CR>
nmap <silent> <M-Right> :wincmd l<CR>
" }}}

" {{{ persistent undo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
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
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-endwise'
Plugin 'leafgarland/typescript-vim'
Plugin 'ciaranm/securemodelines'
Plugin 'fatih/vim-go'
Plugin 'dgryski/vim-godef'

Plugin 'nginx/nginx', {'name': 'nginx-syntax', 'rtp': 'contrib/vim'}

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

" {{{ securemodelines
set modelines=0
let g:secure_modelines_allowed_items = [
      \ "textwidth",   "tw",
      \ "softtabstop", "sts",
      \ "tabstop",     "ts",
      \ "shiftwidth",  "sw",
      \ "expandtab",   "et",   "noexpandtab", "noet",
      \ "filetype",    "ft",
      \ "foldmethod",  "fdm",
      \ "readonly",    "ro",   "noreadonly", "noro",
      \ "backup",      "bkp",  "nobackup", "nobkp",
      \ "autoindent",  "ai",   "noautoindent", "noai",
      \ "shiftround",  "sr",   "noshiftround", "nosr",
      \ "syntax",      "syn"
      \ ]
" }}}

" {{{ autocmd vim
au FileType vim setl et ts=2 sts=2 sw=2 foldmethod=marker
au FileType yaml setl et ts=2 sts=2 sw=2
au FileType yaml setl indentkeys-=<:>

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

aug AutoloadVimrc
  au!
  au BufWritePost .vimrc source $MYVIMRC|set ft=vim
  au BufWritePost .vimrc runtime! plugins/**/*.vim
aug END
" }}}
