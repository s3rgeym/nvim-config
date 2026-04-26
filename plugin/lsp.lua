vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/b0o/schemastore.nvim',
}, { confirm = false })

require('mason').setup()

-- Конфиги самих языковых серверов в ~/.config/nvim/after/lsp. Они рекуривно
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
-- local ok_blink, blink = pcall(require, 'blink.cmp')
-- if ok_blink then
--   capabilities =
--     vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
-- end

-- Настройки для всех серверов
vim.lsp.config('*', { capabilities = capabilities })

-- jsonls специфичные настройки
vim.lsp.config('jsonls', {
  settings = {
    json = {
      -- Дополнение в json через схемы
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Включаем сервера
vim.lsp.enable({ 'rust_analyzer' })

-- Настройка внешнего вида диагностики
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true, only_current_line = true },
  underline = true,
  severity_sort = true,
})

local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

local function feedkeys(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    'n',
    true
  )
end

-- https://mintlify.wiki/neovim/neovim/lsp/completion
local lsp_group = vim.api.nvim_create_augroup('lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local function keymap(lhs, rhs, opts, mode)
      local options = { buffer = bufnr }
      if type(opts) == 'string' then
        options.desc = opts
      else
        options = vim.tbl_extend('force', options, opts)
      end
      vim.keymap.set(mode or 'n', lhs, rhs, options)
    end

    -- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
    if client:supports_method('textDocument/completion') then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end

      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

      keymap('<cr>', function()
        return pumvisible() and '<C-y>' or '<cr>'
      end, { expr = true }, 'i')

      keymap('<C-Space>', function()
        vim.lsp.completion.get()
      end, 'Trigger Completion', 'i')

      -- keymap('/', function()
      --   return pumvisible() and '<C-e>' or '/'
      -- end, { expr = true }, 'i')

      keymap('<Tab>', function()
        return pumvisible() and '<C-n>' or '<Tab>'
      end, { expr = true }, 'i')

      keymap('<S-Tab>', function()
        return pumvisible() and '<C-p>' or '<S-Tab>'
      end, { expr = true }, 'i')

      keymap('<Esc>', function()
        return pumvisible() and '<C-c>' or '<Esc>'
      end, { expr = true }, 'i')
    end

    keymap('K', vim.lsp.buf.hover, 'Show Documentation')
    keymap('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
    keymap('gl', vim.diagnostic.open_float, 'Line Diagnostics')
    keymap('[d', function()
      vim.diagnostic.jump({ count = -1 })
    end, 'Prev Diagnostic')
    keymap(']d', function()
      vim.diagnostic.jump({ count = 1 })
    end, 'Next Diagnostic')

    -- Включаем Inlay Hints по умолчанию
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true)
      keymap('<leader>i', function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        )
      end, 'Toggle Inlay [H]ints')
    end

    -- Подсветка упоминаний символа под курсором
    if client:supports_method('textDocument/documentHighlight') then
      local highlight_group =
        vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
      vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Неудобно, что при выборе части пути, его автодополнение завершается
vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    local e = vim.v.event
    if e.complete_type == 'files' and e.reason == 'accept' then
      feedkeys('<C-x><C-f>')
    end
  end,
})
