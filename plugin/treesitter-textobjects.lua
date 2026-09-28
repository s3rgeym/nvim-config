vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

require('nvim-treesitter-textobjects').setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
  },
})

-- Select
-- Как запомнить: around/inner function/class/section
vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@function.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@class.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'aa', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@parameter.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ia', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@parameter.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ab', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@block.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ib', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@block.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'al', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@loop.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'il', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@loop.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'ao', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@conditional.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'io', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@conditional.inner',
    'textobjects'
  )
end)

-- Move
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@parameter.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@parameter.inner',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']b', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@block.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[b', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@block.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@conditional.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[o', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@conditional.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']l', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@loop.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[l', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@loop.outer',
    'textobjects'
  )
end)
