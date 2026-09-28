vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' })

require('nvim-treesitter-textobjects').setup({
  textobjects = {
    select = {
      lookahead = true,
    },
  },
})

-- Как запомнить: around/inner method/class/section
vim.keymap.set({ 'x', 'o' }, 'am', function()
  require('nvim-treesitter-textobjects.select').select_textobject(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'x', 'o' }, 'im', function()
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

vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  require('nvim-treesitter-textobjects.move').goto_next_start(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_end(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
  require('nvim-treesitter-textobjects.move').goto_next_end(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start(
    '@class.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end(
    '@function.outer',
    'textobjects'
  )
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end(
    '@class.outer',
    'textobjects'
  )
end)
