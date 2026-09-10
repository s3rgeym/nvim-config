vim.pack.add({
  -- В Neovim 0.13+ async будет встроенным
  'https://github.com/lewis6991/async.nvim',
  'https://github.com/ThePrimeagen/refactoring.nvim',
})

require('refactoring').setup {}

local keymap = vim.keymap

keymap.set({ 'n', 'x' }, '<leader>rf', function()
  return require('refactoring').extract_func()
end, { desc = 'Extract Function', expr = true })

keymap.set({ 'n', 'x' }, '<leader>rv', function()
  return require('refactoring').extract_var()
end, { desc = 'Extract Variable', expr = true })

keymap.set({ 'n', 'x' }, '<leader>rr', function()
  return require('refactoring').select_refactor()
end, { desc = 'Select refactor' })
