-- Просмотр сочетаний клавиш

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    triggers = {
      -- по умолчанию в mode содержится "x", из-за чего при выделении текста с Shift показываются сочетания с v
      { "<auto>", mode = "nso" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
