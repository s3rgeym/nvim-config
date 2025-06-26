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
    -- Поиск по тексту
    { "<leader>/",   "<cmd>FzfLua grep_curbuf<CR>",               desc = "Grep current buffer" },
    { "<leader>b",   "<cmd>FzfLua buffers<CR>",                   desc = "Buffers" },
    { "<leader>f",   "<cmd>FzfLua live_grep<CR>",                 desc = "Find using grep (ripgrep)" },
    { "<leader>F",   "<cmd>FzfLua files<CR>",                     desc = "Find file (fd)" },
    { "<leader>o",   "<cmd>FzfLua oldfiles<CR>",                  desc = "Recent files" },
    { "<leader>r",   "<cmd>FzfLua resume<CR>",                    desc = "Resume last search" },

    -- Работа с LSP
    { "<leader>fd",  "<cmd>FzfLua lsp_definitions<CR>",           desc = "LSP: Go to definition (FZF)" },
    { "<leader>fD",  "<cmd>FzfLua lsp_declarations<CR>",          desc = "LSP: Go to declaration (FZF)" },
    { "<leader>fi",  "<cmd>FzfLua lsp_implementations<CR>",       desc = "LSP: Go to implementation (FZF)" },
    { "<leader>fr",  "<cmd>FzfLua lsp_references<CR>",            desc = "LSP: List references (FZF)" },
    { "<leader>ft",  "<cmd>FzfLua lsp_typedefs<CR>",              desc = "LSP: Type definition (FZF)" },
    { "<leader>fa",  "<cmd>FzfLua lsp_code_actions<CR>",          desc = "LSP: Code actions (FZF)" },
    { "<leader>fld", "<cmd>FzfLua lsp_document_diagnostics<CR>",  desc = "Document diagnostics (FZF)" },
    { "<leader>fs",  "<cmd>FzfLua lsp_document_symbols<CR>",      desc = "Document symbols (FZF)" },
    { "<leader>fws", "<cmd>FzfLua lsp_workspace_symbols<CR>",     desc = "Workspace symbols (FZF)" },
    { "<leader>fwd", "<cmd>FzfLua lsp_workspace_diagnostics<CR>", desc = "Workspace diagnostics (FZF)" },
  }
}
