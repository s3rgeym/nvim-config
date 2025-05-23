return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua", -- fix: Not and editor command: FzfLua ...
  opts = {},
  keys = {
    { "<leader>/", "<cmd>FzfLua grep_curbuf<CR>", desc = "Grep current buffer" },
    { "<leader>b", "<cmd>FzfLua buffers<CR>",     desc = "Buffers" },
    { "<leader>f", "<cmd>FzfLua live_grep<CR>",   desc = "Find using grep (ripgrep)" },
    { "<leader>F", "<cmd>FzfLua files<CR>",       desc = "Find file (fd)" },
    { "<leader>o", "<cmd>FzfLua oldfiles<CR>",    desc = "Recent files" },
    { "<leader>r", "<cmd>FzfLua resume<CR>",      desc = "Resume last search" },
  }
}
