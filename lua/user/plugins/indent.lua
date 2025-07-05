-- Отделение отступов вертикальными символами

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "▏", -- |, ¦, ┆
    }
  },
}
