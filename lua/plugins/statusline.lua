return {
  "nvim-lualine/lualine.nvim",
  dependencies = 'nvim-tree/nvim-web-devicons',
  -- Функция config нужна
  config = function()
    require('lualine').setup({
      sections = {
        lualine_x = {
          -- Добавим отображение раскладки
          {
            function()
              if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
                return '⌨ ' .. vim.b.keymap_name
              end
              return ''
            end,
            cond = function() -- Показывать только если раскладка активна
              return vim.opt.iminsert:get() > 0 and vim.b.keymap_name ~= nil
            end,
          },
          'encoding',
          'fileformat',
          'filetype',
        }
      }
    })
  end
}
