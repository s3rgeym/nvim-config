return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = {
    -- Поиск
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find using grep" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find file" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
    -- Работа с LSP
    { "<leader>qf", "<cmd>Telescope quickfix<cr>", desc = "QuickFix" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
  },
}
