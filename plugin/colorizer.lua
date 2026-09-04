-- Этот плагин только для фронтендеров будет полезен
vim.pack.add(
  { 'https://github.com/NvChad/nvim-colorizer.lua' },
  { confirm = false }
)

require('colorizer').setup {}
