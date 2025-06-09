local map = require("user.utils").map

local function on_attach(_, bufnr)
  local function nmap(keys, func, desc)
    map('n', keys, func, "LSP: " .. desc, { buffer = bufnr })
  end
  -- vim.lsp.buf.definition
  nmap("gd", "<cmd>FzfLua lsp_definitions<CR>", "Go to definition")
  -- vim.lsp.buf.declaration
  nmap("gD", "<cmd>FzfLua lsp_declarations<CR>", "Go to declaration")
  -- vim.lsp.buf.implementation
  nmap("gi", "<cmd>FzfLua lsp_implementations<CR>", "Go to implementation")
  -- vim.lsp.buf.references
  nmap("gr", "<cmd>FzfLua lsp_references<CR>", "List references")
  -- vim.lsp.buf.code_action
  nmap("<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", "Code actions")
  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("K", vim.lsp.buf.hover, "Hover documentation")
  nmap("gK", vim.lsp.buf.signature_help, "Signature help")
  nmap("<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format document")
  local function jump(c)
    vim.diagnostic.jump({ count = c })
  end
  nmap("[d", function() jump(-1) end, "Previous diagnostic")
  nmap("]d", function() jump(1) end, "Next diagnostic")
  -- nmap("<leader>d", vim.diagnostic.open_float, "Show diagnostics")
  nmap("<leader>d", "<cmd>FzfLua lsp_document_diagnostics<CR>", "Diagnostics (fzf)")
  nmap("<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", "Document symbols")
  nmap("<leader>dw", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace symbols")
  nmap("<leader>qf", "<cmd>FzfLua grep_quickfix<CR>", "Quickfix")
end

-- :help lspconfig-all
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Автоматическая установка и настройка языковых серверов
    -- Вынес в отдельный файл
    -- require("mason").setup()
    require("mason-lspconfig").setup({
      -- Список серверов: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
      ensure_installed = {
        "eslint",
        "gopls",
        "lua_ls",
        "pyright",
        "ruff",
      },
      automatic_installation = true,
    })

    vim.lsp.config("*", {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Настройка уже установленных серверов
    local servers = {
      -- Сюда вписываем названия серверов, которые уже установлены в системе
      -- 'rust-analyzer'
    }

    for _, lsp in ipairs(servers) do
      vim.lsp.enable(lsp)
    end
  end
}
