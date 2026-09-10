-- По факту он нужен только для работы с обычным текстом, переименование объектов нужно делать через LSP
vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

local grug_far = require('grug-far')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>sr', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug_far.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  })
end, { desc = 'Search and Replace' })
