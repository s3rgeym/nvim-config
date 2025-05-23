-- Просмотр сочетаний клавиш

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- helix компактнее, но в этот больше вмещается
    preset = "modern",
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
