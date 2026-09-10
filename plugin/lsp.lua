local utils = require('utils')

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/b0o/schemastore.nvim',
})

require('mason').setup()

vim.keymap.set('n', '<leader>M', '<cmd>Mason<cr>', { desc = 'Open Mason' })

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- blink.cmp больше не нужен!
-- local ok_blink, blink = pcall(require, 'blink.cmp')
-- if ok_blink then
--   capabilities =
--     vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
-- end

-- Настройки для всех серверов
vim.lsp.config('*', { capabilities = capabilities })

-- Специфичные настройки jsonls
vim.lsp.config('jsonls', {
  settings = {
    json = {
      -- Дополнение в json через схемы
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Включаем сервера вручную (эта утилита ставится вместе с растом и ставить ее
-- отдельно через Mason лишнее)
vim.lsp.enable({ 'rust_analyzer' })

-- Настройка внешнего вида диагностики
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
    focusable = false,
  },
})

-- Автоматически открывать float при остановке курсора
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- Задержка перед срабатыванием CursorHold (в миллисекундах)
vim.opt.updatetime = 300

-- https://mintlify.wiki/neovim/neovim/lsp/completion
local lsp_group = vim.api.nvim_create_augroup('lsp', { clear = true })

local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

-- local function feedkeys(keys, mode)
--   local termocodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
--   vim.api.nvim_feedkeys(termocodes, mode or 'n', true)
-- end

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local function map(mode, lhs, rhs, opts)
      opts = type(opts) == 'string' and { desc = opts } or opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- По умолчанию автодополнение вызывается при вводе ".", но это не очень
    -- удобно, привычнее когда варианты автоподстановки показываются при вводе
    -- любого символа (тут только печатные ASCII).
    if client:supports_method('textDocument/completion') then
      local chars = {}

      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end

      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

      map('i', '<cr>', function()
        return vim.fn.pumvisible() == 1 and '<C-y>' or '<cr>'
      end, { expr = true })

      map('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end, 'Trigger Completion')

      -- Закрыть меню и отменить подстановку
      -- Можно на <Esc> повесить
      map('i', '/', function()
        return pumvisible() and '<C-e>' or '/'
      end, { expr = true })

      -- Вызываем автодополнение по Ctrl-N
      map('i', '<C-n>', function()
        return pumvisible() and '<C-n>' or '<C-x><C-o>'
      end, { expr = true })

      -- Сниппеты по дефолту работают и специальных сочетаний для них не нужно
      -- https://neovim.io/doc/user/lua/#vim.snippet.jump()
      -- Сложно привыкнуть к <C-n>/<C-p>
      map('i', '<Tab>', function()
        return pumvisible() and '<C-n>' or '<Tab>'
      end, { expr = true })

      map('i', '<S-Tab>', function()
        return pumvisible() and '<C-p>' or '<S-Tab>'
      end, { expr = true })
    end

    -- Сочетания типа K, [d, ]d теперь по дефолту, а для <leader>ca есть gra

    -- Это сочетание не всегда связано с LSP по умолчанию, поэтому его нужно
    -- прописать явно
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    -- map('n', 'gl', vim.diagnostic.open_float, 'Line Diagnostics')
    map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

    -- Включаем Inlay Hints по умолчанию
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true)

      -- А нужна ли вообще возможность отключать их?
      map('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        )
      end, 'Toggle Inlay Hints')
    end

    -- Подсветка упоминаний символа под курсором
    if client:supports_method('textDocument/documentHighlight') then
      local group =
        vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

      vim.api.nvim_clear_autocmds({
        group = group,
        buffer = bufnr,
      })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
