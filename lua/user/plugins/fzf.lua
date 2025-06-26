return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
  },
  cmd = "FzfLua", -- fix: Not and editor command: FzfLua ...
  config = function()
    require('fzf-lua').setup()
    require('fzf-lua').register_ui_select()
    local config = require("fzf-lua.config")
    local actions = require("trouble.sources.fzf").actions
    config.defaults.actions.files["ctrl-t"] = actions.open
  end,
  keys = {
    { "<leader>/", "<cmd>FzfLua grep_curbuf<CR>", desc = "Grep current buffer" },
    { "<leader>b", "<cmd>FzfLua buffers<CR>",     desc = "Buffers" },
    { "<leader>f", "<cmd>FzfLua live_grep<CR>",   desc = "Find using grep (ripgrep)" },
    { "<leader>F", "<cmd>FzfLua files<CR>",       desc = "Find file (fd)" },
    { "<leader>o", "<cmd>FzfLua oldfiles<CR>",    desc = "Recent files" },
    { "<leader>r", "<cmd>FzfLua resume<CR>",      desc = "Resume last search" },
  }
}
