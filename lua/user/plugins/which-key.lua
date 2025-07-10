-- Просмотр сочетаний клавиш

return {
  "folke/which-key.nvim",
  -- Позволяет импортировать which-key в любом месте
  lazy = false,
  opts = {
    preset = "helix",
    triggers = {
      -- по умолчанию в mode содержится "x", из-за чего при выделении текста с Shift показываются сочетания с v
      { "<auto>",   mode = "nisotc" },
      { "<leader>", mode = { "n", "v" } },
      { "g",        mode = "v" },
    },
  },
}
