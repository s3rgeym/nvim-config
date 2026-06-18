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
  -- winopts = {
  --   border = 'rounded',
  -- },
  -- preview = {
  --   border = 'single',
  -- },
})

fzf.register_ui_select()

vim.keymap.set('n', '<C-g>', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep' })
-- Я заменил рекомендованное <C-\\>
vim.keymap.set('n', '<C-;>', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>', { desc = 'Files' })

-- Прочие сочетания с f от fzf
vim.keymap.set(
  'n',
  -- Сам разработчик советует использовать <C-k>, но это сочетание
  -- используется для выбора окон
  '<leader>fk',
  '<cmd>FzfLua builtin<cr>',
  { desc = 'FZF Commands' }
)
vim.keymap.set(
  'n',
  '<leader>fo',
  '<cmd>FzfLua oldfiles<cr>',
  { desc = 'Recent Files' }
)
vim.keymap.set('n', '<leader>fj', '<cmd>FzfLua jumps<cr>', { desc = 'Jumps' })
-- Можно удалить, так как смена тем требуется не часто
vim.keymap.set(
  'n',
  '<leader>ft',
  '<cmd>FzfLua colorschemes<cr>',
  { desc = 'FZF Themes' }
)
vim.keymap.set('n', '<leader>fr', '<cmd>FZF resume<cr>', { desc = 'Resume' })

-- LSP
-- Переопределение встроенных сочетаний в Neovim 0.10+
vim.keymap.set(
  { 'n', 'v' },
  'gra',
  '<cmd>FzfLua lsp_code_actions<cr>',
  { desc = 'Code Action' }
)
vim.keymap.set(
  'n',
  'grr',
  '<cmd>FzfLua lsp_references<cr>',
  { desc = 'References' }
)
vim.keymap.set(
  'n',
  'gri',
  '<cmd>FzfLua lsp_implementations<cr>',
  { desc = 'Implementations' }
)
vim.keymap.set(
  'n',
  'grt',
  '<cmd>FzfLua lsp_typedefs<cr>',
  { desc = 'Type Definition' }
)

-- Прочие сочетания для LSP
vim.keymap.set(
  'n',
  '<leader>ls',
  '<cmd>FzfLua lsp_document_symbols<cr>',
  { desc = 'Document Symbols' }
)
vim.keymap.set(
  'n',
  '<leader>lS',
  '<cmd>FzfLua lsp_workspace_symbols<cr>',
  { desc = 'Workspace Symbols' }
)
vim.keymap.set(
  'n',
  '<leader>ld',
  '<cmd>FzfLua diagnostics_document<cr>',
  { desc = 'Document Diagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>lD',
  '<cmd>FzfLua diagnostics_workspace<cr>',
  { desc = 'Workspace Diagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>lf',
  '<cmd>FzfLua lsp_finder<cr>',
  { desc = 'LSP Finder' }
)

-- Git
vim.keymap.set(
  'n',
  '<leader>gb',
  '<cmd>FzfLua git_branches<cr>',
  { desc = 'Git Branches' }
)
vim.keymap.set(
  'n',
  '<leader>gc',
  '<cmd>FzfLua git_commits<cr>',
  { desc = 'Git Commits' }
)
vim.keymap.set(
  'n',
  '<leader>gf',
  '<cmd>FzfLua git_files<cr>',
  { desc = 'Git Files' }
)
vim.keymap.set(
  'n',
  '<leader>gs',
  '<cmd>FzfLua git_status<cr>',
  { desc = 'Git Status' }
)
