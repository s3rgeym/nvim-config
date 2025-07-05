-- Просмотр сочетаний клавиш

return {
  "folke/which-key.nvim",
  -- Позволяет импортировать which-key в любом месте
  event = "VeryLazy",
  opts = {
    preset = "helix",
    triggers = {
      -- по умолчанию в mode содержится "x", из-за чего при выделении текста с Shift показываются сочетания с v
      -- { "<auto>",   mode = "nixsotc" },
      { "<leader>", mode = { "n", "v" } },
    },
  },
}
