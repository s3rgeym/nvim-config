return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = {
    -- Поиск
    { "<leader>f",  "<cmd>Telescope live_grep<cr>",             desc = "Find using grep" },
    { "<leader>F",  "<cmd>Telescope find_files<cr>",            desc = "Find file" },
    { "<leader>b",  "<cmd>Telescope buffers<cr>",               desc = "Find buffer" },

    -- Работа с LSP
    { "<leader>qf", "<cmd>Telescope quickfix<cr>",              desc = "QuickFix" },
    { "gr",         "<cmd>Telescope lsp_references<cr>",        desc = "References" },
    { "gi",         "<cmd>Telescope lsp_implementations<cr>",   desc = "Implementations" },
    { "gd",         "<cmd>Telescope lsp_definitions<cr>",       desc = "Definitions" },
    { "<leader>d",  "<cmd>Telescope diagnostics<cr>",           desc = "Diagnostics (workspace)" },
    { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
    { "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>ll", "<cmd>Telescope loclist<cr>",               desc = "Location List" },
  },
}
