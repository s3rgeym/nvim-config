-- Многофункциональный плагин на основе fzf
-- Лучше задать через .fzfrc
-- vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
}, { confirm = false })

local fzf = require('fzf-lua')

fzf.setup({
  fzf_colors = true,
  winopts = {
    border = 'rounded',
  },
  preview = {
    border = 'single',
  },
})

fzf.register_ui_select()

local map = require('utils').map

map('<C-g>', '<cmd>FzfLua grep<cr>', 'Grep')
map('<C-\\>', '<cmd>FzfLua buffers<cr>', 'Buffers')
map('<C-p>', '<cmd>FzfLua files<cr>', 'Files')
map('<leader>fo', '<cmd>FzfLua oldfiles<cr>', 'Old Files')
map('<leader>ft', '<cmd>FzfLua colorschemes<cr>', 'Switch Theme')
map('<leader>fc', '<cmd>FzfLua builtin<cr>', 'FZF Command Palette')

-- LSP
-- Переопределение встроенных сочетаний в Neovim 0.10+
map('gra', '<cmd>FzfLua lsp_code_actions<cr>', 'Code Action', { 'n', 'v' })
map('grr', '<cmd>FzfLua lsp_references<cr>', 'References')
map('gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations')
map('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Type Definition')

map('<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document Symbols')
map('<leader>lS', '<cmd>FzfLua lsp_workspace_symbols<cr>', 'Workspace Symbols')
map(
  '<leader>ld',
  '<cmd>FzfLua diagnostics_document<cr>',
  'Document Diagnostics'
)
map(
  '<leader>lD',
  '<cmd>FzfLua diagnostics_workspace<cr>',
  'Workspace Diagnostics'
)
map('<leader>lf', '<cmd>FzfLua lsp_finder<cr>', 'LSP Finder')

-- Git
map('<leader>gb', '<cmd>FzfLua git_branches<cr>', 'Git Branches')
map('<leader>gc', '<cmd>FzfLua git_commits<cr>', 'Git Commits')
map('<leader>gf', '<cmd>FzfLua git_files<cr>', 'Git Files')
map('<leader>gs', '<cmd>FzfLua git_status<cr>', 'Git Status')
