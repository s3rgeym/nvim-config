vim.pack.add({ 'https://github.com/stevearc/aerial.nvim' }, { confirm = false })
require('aerial').setup({})
local map = require('utils').map
map('<leader>a', '<cmd>AerialToggle!<CR>')
