vim.pack.add({ 'https://github.com/stevearc/aerial.nvim' }, { confirm = false })
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
  layout = {
    -- default_direction = 'prefer_left',
    min_width = 15,
  },
})
-- You probably also want to set a keymap to toggle aerial
-- <leader>cs - Code Symbols
-- <leader>co - Code Outline
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
