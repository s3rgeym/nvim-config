local utils = require('user.utils')

local function on_attach(_, bufnr)
  local function map(keys, func, desc)
    utils.map('n', keys, func, "LSP: " .. desc, { buffer = bufnr })
  end

  -- Стандартные LSP-команды
  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gi", vim.lsp.buf.implementation, "Go to implementation")
  map("gr", vim.lsp.buf.references, "List references")
  map("gy", vim.lsp.buf.type_definition, "Type definition")
  map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("K", vim.lsp.buf.hover, "Hover documentation")
  map("gK", vim.lsp.buf.signature_help, "Signature help")
  map("<leader>d", vim.diagnostic.open_float, "Show diagnostics")

  local function jump(c)
    vim.diagnostic.jump({ count = c })
  end

  map("[d", function() jump(-1) end, "Previous diagnostic")
  map("]d", function() jump(1) end, "Next diagnostic")

  map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
  map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
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

    -- Настройки диагностики
    vim.diagnostic.config({
      signs = true,
      virtual_text = false,
      virtual_lines = { current_line = true },
      -- severity = { min = vim.diagnostic.severity.WARN },
      update_in_insert = false,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format {
          async = false
        }
      end,
    })

    -- Если хочется в всплывающем окне показывать ошибки
    -- На CursorMove можно вешать
    -- -- ... и при наведении сообщения
    -- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    --   callback = function()
    --     vim.diagnostic.open_float(nil, { focus = false })
    --   end
    -- })
    --
    -- -- Форматирование при сохранении
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   callback = function()
    --     vim.lsp.buf.format {
    --       async = false
    --     }
    --   end,
    -- })
  end
}
