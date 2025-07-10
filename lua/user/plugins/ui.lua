return {
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Nvim Tree",
            separator = true,
            text_align = "left",
          },
        },
      }
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    -- Функция config нужна
    config = function()
      require('lualine').setup({
        sections = {
          lualine_c = {
            'filename',
            'lsp_status',
          },
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
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false, -- Загружаем сразу
    opts = {
      -- Geovide как-то неправильно работает с этой прозрачностью (через
      -- bg=None).
      -- Включать прозрачность для темы не нужно, если установить
      -- colors.transparent_background_colors = true в настройках alacritty
      -- transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
    },
  },
}
