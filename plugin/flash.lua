vim.pack.add({ 'https://github.com/folke/flash.nvim' }, { confirm = false })

local flash = require('flash')
flash.setup()
-- Другие сочетания мне особо не нужны
vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter)
