" {{{ custom key mappings
cmap w!! w !sudo tee % >/dev/null
" }}}

" {{{ plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'nanotech/jellybeans.vim'
Plug 'rktjmp/lush.nvim'
Plug 'metalelf0/jellybeans-nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'github/copilot.vim'

Plug 'fatih/vim-go'
Plug 'ledger/vim-ledger'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'psliwka/vim-smoothie'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-tree/nvim-web-devicons'
Plug 'vim-test/vim-test'

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'stevearc/aerial.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'nvim-neotest/neotest-vim-test'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvimdev/lspsaga.nvim'
Plug 'stevanmilic/nvim-lspimport'
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

set colorcolumn=120
" }}}

"" {{{ filetype specific settings
au FileType sh setl et ts=4 sts=4 sw=4
au FileType vim setl et ts=2 sts=2 sw=2 foldmethod=marker
au FileType vimwiki setl et ts=2 sts=2 sw=2
au FileType yaml setl et ts=2 sts=2 sw=2
au FileType yaml setl indentkeys-=<:>
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

" {{{ ALE
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_linters = {
  \ 'go': ['gofmt', 'govet', 'staticcheck'],
  \ }
let g:ale_linters_ignore = {
  \ 'python': ['pyright'],
  \ }
let g:ale_python_pylint_options = '--disable=fixme,line-too-long,missing-class-docstring,missing-function-docstring,missing-module-docstring,too-few-public-methods,too-many-arguments,too-many-instance-attributes,unused-argument'
" }}}

" {{{ coc <C-space> [g ]g gd gy gi gr K \a \qf \r \cl if af ic ac <C-s> <space>a <space>e <space>c <space>o <space>s <space>j <space>k <space>p
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline=%<%f\ %h%m%r\ %{coc#status()}%{get(b:,'coc_current_function','')}%=\ %-14.(%l,%c%V%)\ %P
autocmd User CocStatusChange redrawstatus

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" {{{ vim-test
"nmap <silent> <leader>tt :TestNearest<CR>
"nmap <silent> <leader>tT :TestFile<CR>
"nmap <silent> <leader>ta :TestSuite<CR>
"nmap <silent> <leader>tl :TestLast<CR>
"nmap <silent> <leader>tg :TestVisit<CR>
" }}}


lua << EOF
-- {{{ kanagawa
require('kanagawa').setup({
  colors = {
    theme = {
      wave = {
        diff = {
          add = '#214a12',
          delete = '#53091a',
          change = '#202097',
          text = '#2e5bff',
        },
      },
    },
  },
  overrides = function(colors)
    return {}
  end,
  theme = "wave",
  background = {
    dark = "wave",
  },
})
vim.cmd("colorscheme kanagawa")
-- }}}

-- {{{ web-devicons
require("nvim-web-devicons").setup({})
-- }}}

-- {{{ nvim-dap \d
local dap = require("dap")
vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<Leader>dc', dap.continue)
vim.keymap.set('n', '<Leader>dC', dap.run_to_cursor)
vim.keymap.set('n', '<Leader>ds', dap.step_over)
vim.keymap.set('n', '<Leader>di', dap.step_into)
vim.keymap.set('n', '<Leader>do', dap.step_out)
vim.keymap.set('n', '<Leader>dp', dap.step_back)
vim.keymap.set('n', '<Leader>dr', dap.repl.open)
vim.keymap.set('n', '<Leader>dl', dap.run_last)
vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>dS', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set('n', '<Leader>dU', function() dap.up() end)
vim.keymap.set('n', '<Leader>dD', function() dap.down() end)

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized.dapui = function()
  vim.api.nvim_echo({{"", "Normal"}}, false, {})
  dapui.open()
end
dap.listeners.before.event_terminated.dapui = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui = function()
  dapui.close()
end
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "White", bg = "#999900" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#555500" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

require("dap-python").setup("python")
require("nvim-dap-virtual-text").setup()
-- }}}

-- {{{ neotest \t
local neotest = require("neotest")
neotest.setup({
  discovery = {
    enabled = false,
    concurrent = 1,
  },
  running = {
    concurrent = false,
  },
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-vim-test")({
      ignore_file_types = { "python" },
    }),
  },
})
vim.keymap.set('n', '<leader>tt', neotest.run.run, {})
vim.keymap.set('n', '<leader>td', function()
  vim.notify("Starting debug session...", vim.log.levels.INFO)
  vim.api.nvim_echo({{"Starting debug session...", "Identifier"}}, false, {})
  neotest.run.run({ strategy = "dap" })
end, {})
vim.keymap.set('n', '<leader>tT', function() neotest.run.run(vim.fn.expand("%")) end, {})
vim.keymap.set('n', '<leader>tS', neotest.summary.toggle, {})
vim.keymap.set('n', '<leader>to', function() neotest.output.open({ enter = true }) end, {})
-- }}}

-- {{{ telescope \f
local telescope = require("telescope")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set("n", "<leader>fG", telescope.extensions.live_grep_args.live_grep_args, {})

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
  layout = {
    max_width = { 60, 0.2 },
    width = nil,
    min_width = 10,
  },
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Setup telescope
local fzf_opts = {
  fuzzy = true,                    -- false will only do exact matching
  override_generic_sorter = true,  -- override the generic sorter
  override_file_sorter = true,     -- override the file sorter
  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                   -- the default case_mode is "smart_case"
}
local sorters = require("telescope.sorters")

telescope.setup {
  defaults = {
    disable_devicons = true,
  },
  pickers = {
    find_files = {
      disable_devicons = true
    },
    live_grep = {
      disable_devicons = true,
      --additional_args = {"--sort", "path", "-g", "!tests/**", "-g", "!migrations/versions/**", "-g", "!docker_ansible"}
    },
    -- Manually set sorter, for some reason not picked up automatically
    lsp_dynamic_workspace_symbols = {
      sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts),
      disable_devicons = true,
    },
  },
  extensions = {
    fzf = fzf_opts,
  }
}
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
-- }}}

-- {{{ lspconfig <space>e [d ]d gD gd <C-]> <space>w <space>D <space>rn <space>ca gr <space>f
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
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'ts_ls', 'rust_analyzer' }
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

--- {{{ lspsaga
require('lspsaga').setup({
  symbol_in_winbar = { enable = false },
})
--- }}}

--- {{{ lspimport \a
vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true })
--- }}}

--- {{{ calculator \c
local function calculate_selection()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'x', false)

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 0 then return end

  if #lines == 1 then
    lines[1] = lines[1]:sub(start_col, end_col)
  else
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(1, end_col)
  end

  local expression = table.concat(lines, "\n") .. "\n"
  local result = vim.system({"bc"}, {stdin = expression, text = true}):wait()

  if result.code ~= 0 then
    vim.notify("Invalid expression", vim.log.levels.ERROR)
    return
  end

  local output = vim.trim(result.stdout)
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {output})
end

vim.keymap.set("v", "<leader>c", calculate_selection, { desc = "Calculate selection" })
--- }}}
EOF
