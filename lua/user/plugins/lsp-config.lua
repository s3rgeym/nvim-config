local function on_attach(_, bufnr)
  local function map(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = "LSP: " .. desc, buffer = bufnr })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gi", vim.lsp.buf.implementation, "Go to implementation")
  map("gr", vim.lsp.buf.references, "List references")
  map("gy", vim.lsp.buf.type_definition, "Type definition")
  map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("K", vim.lsp.buf.hover, "Hover documentation")
  map("gs", vim.lsp.buf.signature_help, "Signature help")
  map("<leader>d", vim.diagnostic.open_float, "Show diagnostics")

  local function jump(c)
    vim.diagnostic.jump({ count = c })
  end

  map("[d", function() jump(-1) end, "Previous diagnostic")
  map("]d", function() jump(1) end, "Next diagnostic")

  map("<leader>sd", vim.lsp.buf.document_symbol, "Document symbols")
  map("<leader>sw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
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
    -- Настройки диагностики
    vim.diagnostic.config({
      signs = true,
      virtual_text = false,
      severity_sort = true,
      virtual_lines = {
        current_line = true,
        ---@diagnostic disable-next-line: undefined-field
        severity = vim.diagnostic.severity.WARNING,
      },
      update_in_insert = false,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Автоматическая установка и настройка языковых серверов
    -- Вынес в отдельный файл
    -- require("mason").setup()
    require("mason-lspconfig").setup({
      -- Список серверов: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
      -- Используйте :MasonInstall для устнавоки языковых серверов
      ensure_installed = {
        -- "bashls",
        "pyright",
        "ruff",
        "lua_ls",
        "vimls",
      },
      automatic_installation = true,
    })

    vim.lsp.config("*", {
      -- on_attach = on_attach,
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
  end,
}
