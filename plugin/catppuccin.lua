vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

-- Если не применяются специальные настройки, то setup можно не вызывать
-- require 'catppuccin'.setup { transparent_background = true }
vim.cmd.colorscheme 'catppuccin-mocha'
