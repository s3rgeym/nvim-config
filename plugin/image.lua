-- pacman -S imagemagick
vim.pack.add({ 'https://github.com/3rd/image.nvim' }, { confirm = false })

require('image').setup({
  -- У меня в foot поддерживается только sixel, в более современных терминалах
  -- лучше использовать kitty
  backend = 'sixel',
})
