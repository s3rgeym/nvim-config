local map = require("user.utils").map

local function on_attach(_, bufnr)
  local function nmap(keys, func, desc)
    map('n', keys, func, "LSP: " .. desc, { buffer = bufnr })
  end
  nmap("gd", vim.lsp.buf.definition, "Go to definition")
  nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
  nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
  nmap("gr", vim.lsp.buf.references, "List references")
  nmap("gy", vim.lsp.buf.type_definition, "Type definition")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code actions")
  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("K", vim.lsp.buf.hover, "Hover documentation")
  nmap("gK", vim.lsp.buf.signature_help, "Signature help")
  nmap("<leader>d", vim.diagnostic.open_float, "Show diagnostics")
  local function jump(c)
    vim.diagnostic.jump({ count = c })
  end
  nmap("[d", function() jump(-1) end, "Previous diagnostic")
  nmap("]d", function() jump(1) end, "Next diagnostic")
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
    -- Показываем значки
    vim.diagnostic.config({
      signs = true,
      float = { border = "rounded" },
    })

    -- ... и при наведении сообщения
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
      end
    })

    -- Форматирование при сохранении
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format {
          async = false
        }
      end,
    })
  end
}
