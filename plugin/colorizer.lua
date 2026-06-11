-- Этот плагин только для фронтендеров будет полезен
vim.pack.add(
  { 'https://github.com/NvChad/nvim-colorizer.lua' },
  { confirm = false }
)

require('colorizer').setup({
  filetypes = { '*' },
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = 'background',
  },
})
