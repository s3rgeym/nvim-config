-- Этот плагин нужен, так как не все языковые сервера поддерживают
-- форматирование, и не все средства форматирования могут работать через LSP.
-- :MasonInstall ruff stylua biome prettier shellcheck shfmt
-- Если мы форматируем через conform, то настройки, заданные в конфигах lsp не
-- применяются!!!
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

local conform = require('conform')

conform.setup({
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  formatters = {
    shfmt = { prepend_args = { '-i', '2', '-ci', '-s' } },
    prettier = {
      prepend_args = {
        '--no-semi',
        '--single-quote',
        '--tab-width=2',
        '--no-use-tabs',
      },
    },

    -- отдельный форматтер для markdown без форматирования вложенного кода
    prettier_md = {
      inherit = 'prettier',
      prepend_args = {
        '--no-semi',
        '--single-quote',
        '--tab-width=2',
        '--no-use-tabs',
        '--embedded-language-formatting=off',
      },
    },
  },
  formatters_by_ft = {
    php = { 'php_cs_fixer' },
    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    bash = { 'shfmt' },
    javascript = { 'biome' },
    typescript = { 'biome' },
    vue = { 'prettier' },
    json = { 'biome' },
    jsonc = { 'biome' },
    html = { 'prettier' },
    css = { 'biome' },
    scss = { 'biome' },
    yaml = { 'prettier' },
    markdown = { 'prettier_md' },
  },
})

vim.keymap.set('n', '<leader>cf', function()
  conform.format({ lsp_format = 'fallback' })
end, { desc = 'Code Format' })
