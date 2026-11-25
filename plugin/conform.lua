-- Этот плагин нужен, так как не все языковые сервера поддерживают
-- форматирование, и не все средства форматирования могут работать через LSP.
-- Если форматируем через conform, настройки из конфигов LSP не применяются!
--
-- Плагин ставится встроенным менеджером Neovim 0.12+, обновляется через
-- :lua vim.pack.update()
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

-- Форматтеры (внешние программы) ставятся через pacman, команды указаны
-- над каждым типом файлов в formatters_by_ft ниже.
-- Для типов файлов без форматтера в conform (dockerfile и т.д.)
-- форматирует LSP благодаря lsp_format = 'fallback'.

local conform = require('conform')

conform.setup({
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = 'fallback', -- нет форматтера в conform -> форматирует LSP
  },

  formatters = {
    shfmt = { prepend_args = { '-i', '2', '-ci', '-s' } },
  },

  formatters_by_ft = {
    -- sudo pacman -S composer
    -- composer global require friendsofphp/php-cs-fixer
    -- (~/.local/bin должен быть в $PATH)
    php = { 'php_cs_fixer' },

    -- sudo pacman -S ruff
    -- порядок важен: сначала автофиксы, потом импорты, форматирование в конце
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },

    -- sudo pacman -S stylua
    lua = { 'stylua' },

    -- sudo pacman -S go go-tools
    go = { 'goimports', 'gofmt' },

    -- sudo pacman -S shfmt
    sh = { 'shfmt' },
    bash = { 'shfmt' },

    -- pnpm add -D oxfmt
    javascript = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescript = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
    json = { 'oxfmt' },
    jsonc = { 'oxfmt' },
    json5 = { 'oxfmt' },
    css = { 'oxfmt' },
    scss = { 'oxfmt' },
    less = { 'oxfmt' },
    graphql = { 'oxfmt' },
    toml = { 'oxfmt' },
    yaml = { 'oxfmt' },
    markdown = { 'oxfmt' },
    html = { 'oxfmt' },
    vue = { 'oxfmt' },
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  conform.format({ lsp_format = 'fallback' })
end, { desc = 'Code Format' })
