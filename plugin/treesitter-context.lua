-- nvim-treesitter как зависимость не нужен
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-context' })

require('treesitter-context').setup({
  -- How many lines the window should span. Values <= 0 mean no limit.
  max_lines = 3,
  -- Line used to calculate context. Choices: 'cursor', 'topline'
  mode = 'cursor',
})
