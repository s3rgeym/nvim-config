-- :MasonInstall ruff stylua biome prettier shellcheck shfmt
-- Если мы форматируем через conform, то настройки, заданные в конфигах lsp не
-- применяются!!!
vim.pack.add(
  { 'https://github.com/stevearc/conform.nvim' },
  { confirm = false }
)

local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    php = { 'php_cs_fixer' },
    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt' },
    bash = { 'shfmt' },
    javascript = { 'biome' },
    typescript = { 'biome' },
    vue = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    html = { 'prettier' },
    css = { 'biome' },
    scss = { 'biome' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  formatters = {
    shfmt = { prepend_args = { '-i', '2', '-ci', '-s' } },
  },
})

require('utils').map('<leader>cf', function()
  conform.format({ lsp_format = 'fallback' })
end, 'Code Format')
