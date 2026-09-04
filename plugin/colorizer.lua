-- Отображает цвет css-свойст и тд
vim.pack.add(
  { 'https://github.com/NvChad/nvim-colorizer.lua' },
  { confirm = false }
)

require('colorizer').setup {}
