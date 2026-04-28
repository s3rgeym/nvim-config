-- pacman -S imagemagick
vim.pack.add({ 'https://github.com/3rd/image.nvim' }, { confirm = false })

require('image').setup({ backend = 'sixel' })
