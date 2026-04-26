vim.pack.add({ 'https://github.com/stevearc/aerial.nvim' }, { confirm = false })
require('aerial').setup({})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
