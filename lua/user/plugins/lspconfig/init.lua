-- :help lspconfig-all
-- Список серверов: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local on_attach = require("user.plugins.lspconfig.on_attach").on_attach
    local capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    -- Автоматическая установка и настройка языковых серверов
    -- Вынес в отдельный файл
    -- require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "ruff", "gopls" },
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
