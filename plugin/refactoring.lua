-- Кривой плагин... Я бы лучше написал, если бы знал как
vim.pack.add {
  -- `async.nvim` is only required for Neovim 0.12. If you are using Neovim 0.13, you don't need it
  'https://github.com/lewis6991/async.nvim',
  'https://github.com/theprimeagen/refactoring.nvim',
}

-- calling `require("refactoring").setup()` is not required for the plugin to work
vim.keymap.set('v', '<leader>r', function()
  require('refactoring').select_refactor()
end, { desc = 'Refactoring' })
