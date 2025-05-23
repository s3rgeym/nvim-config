return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "<leader>f", "<cmd>FzfLua live_grep<CR>",   desc = "Find using grep (ripgrep)" },
    { "<leader>F", "<cmd>FzfLua files<CR>",       desc = "Find file (fd)" },
    { "<leader>/", "<cmd>FzfLua grep_curbuf<CR>", desc = "Grep current buffer" },
    { "<leader>r", "<cmd>FzfLua resume<CR>",      desc = "Resume last search" },
  }
}
