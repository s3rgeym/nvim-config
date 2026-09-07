-- sudo pacman -S imagemagick
vim.pack.add({ 'https://github.com/3rd/image.nvim' })
require('image').setup({
  backend = 'sixel', -- foot не поддерживает kitty
})
