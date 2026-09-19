-- Этот плагин можно грузить как до настройки lsp, так и после.
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
    'biome', -- Форматирует код на JavaScript, TypeScript, JSX, TSX, JSON, HTML, CSS и GraphQ
    'cssls',
    'docker_language_server',
    'docker_compose_language_service',
    'html',
    'jsonls',
    'lua_ls',
    'ruff',
    'stylua',
    'tombi', -- LSP/Formatter for TOML
    'ts_ls', -- JS/TS
    'vimls',
    'yamlls',
  },
})

vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'Open Mason' })
