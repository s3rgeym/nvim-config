return {
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
}
