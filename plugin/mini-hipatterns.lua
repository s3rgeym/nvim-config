vim.pack.add({ 'https://github.com/echasnovski/mini.hipatterns' })

local hipatterns = require('mini.hipatterns')
hipatterns.setup {
  highlighters = {
    hex_0x = {
      -- ровно 6 hex-цифр после 0x, дальше не "словный" символ
      pattern = '0x%x%x%x%x%x%x%f[%W]',
      group = function(_, _, data)
        local hex = data.full_match:gsub('^0x', '#')
        return hipatterns.compute_hex_color_group(hex, 'bg')
      end,
    },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}
