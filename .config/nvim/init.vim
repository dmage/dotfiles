" {{{ plugins
call plug#begin()
Plug 'fatih/vim-go'
Plug 'github/copilot.vim'
Plug 'ledger/vim-ledger'
Plug 'mhinz/vim-signify'
Plug 'nanotech/jellybeans.vim'
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'
Plug 'psliwka/vim-smoothie'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim' " required by null-ls
Plug 'jose-elias-alvarez/null-ls.nvim'
call plug#end()
" }}}

"" {{{ core vim settings
" restore cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" automatically reload vim config
aug AutoloadVimrc
  au!
  au BufWritePost $MYVIMRC source %
aug END

" enable mouse in normal mode
set mouse=n
" }}}

"" {{{ filetype specific settings
au FileType sh setl et ts=4 sts=4 sw=4
au FileType vim setl et ts=2 sts=2 sw=2 foldmethod=marker
au FileType vimwiki setl et ts=2 sts=2 sw=2
au FileType yaml setl et ts=2 sts=2 sw=2
au FileType yaml setl indentkeys-=<:>
" }}}

" {{{ colors
set t_Co=256
let g:jellybeans_overrides = {
  \ 'NormalFloat': { 'guibg': '444444' },
  \ 'DiagnosticInfo': { 'guifg': '005fff' },
  \ 'DiagnosticFloatingError': { 'guifg': 'ff6666' },
  \ 'DiagnosticFloatingInfo': { 'guifg': '669fff' },
  \ }
colorscheme jellybeans
hi link xmlEndTag Function
" }}}

" {{{ GitHub Copilot
let g:copilot_filetypes = {
  \ 'ledger': v:false,
  \ }
" }}}

" {{{ smooth animation
let g:smoothie_speed_constant_factor = 15
let g:smoothie_speed_linear_factor = 15
" }}}

" {{{ vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_hl_cb_checked = 2
" }}}

" {{{ vim-go
let g:go_doc_popup_window = 1
" }}}

lua << EOF
-- {{{ lspconfig
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
-- }}}

-- {{{ null-ls
require("null-ls").setup {
  sources = {
    require("null-ls").builtins.diagnostics.flake8.with {
      extra_args = { "--extend-ignore=F401" },
    },
    require("null-ls").builtins.code_actions.shellcheck,
    require("null-ls").builtins.diagnostics.shellcheck,
    require("null-ls").builtins.diagnostics.staticcheck,
  },
}
-- }}}
EOF
