return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local on_attach = require("user.plugins.lsp.on_attach").on_attach
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local servers = {
      'lua_ls',
      'gopls',
      'ruff', -- Не поддерживает автодополнения, поэтому используется только в сочетании с pyright
      'pyright',
    }

    -- Пока что новый синтаксис не работает
    -- vim.lsp.config("*", {
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    -- })

    -- for _, lsp in ipairs(servers) do
    --   vim.lsp.enable(lsp)
    -- end

    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
      }
    end
  end
}
