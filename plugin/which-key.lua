vim.pack.add({ 'https://github.com/folke/which-key.nvim' }, { confirm = false })

local wk = require('which-key')
wk.setup({
  preset = 'modern',
  -- spec = {
  --   { '<leader>b', group = 'Buffers' },
  --   { '<leader>d', group = 'Debug' },
  --   { '<leader>g', group = 'Git' },
  --   { '<leader>l', group = 'LSP' },
  -- },
})

vim.keymap.set('n', '<leader>?', function()
  wk.show({ global = false })
end, { desc = 'Buffer Local Keymaps (which-key)' })
