return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = {
    { "<leader>/", "<cmd>Telescope find_files<cr>", desc = "Find file" },
    { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Find using grep" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
  },
}
