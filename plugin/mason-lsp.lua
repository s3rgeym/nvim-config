vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
})

require('mason').setup()

-- Конфиги самих языковых серверов в ~/.config/nvim/after/lsp. Они рекурсивно
-- объединяются со встроенными.
-- Полностью переопределить конфиги можно в ~/.config/nvim/lsp.
require('mason-lspconfig').setup({
  ensure_installed = {
    'basedpyright',
    'bashls',
    'biome',
    'clangd',
    'cssls',
    'docker_compose_language_service',
    'docker_language_server',
    'gopls',
    'html',
    'jsonls',
    'lua_ls',
    'ruff',
    'stylua',
    'vimls',
    'vtsls',
    'vue_ls',
    'yamlls',
  },
})

vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'Open Mason' })
