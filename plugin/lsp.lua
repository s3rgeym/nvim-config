vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/b0o/schemastore.nvim',
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

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

-- Настройка внешнего вида диагностики
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
})

-- Автоматически открывать float при остановке курсора
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- https://mintlify.wiki/neovim/neovim/lsp/completion
local lsp_group = vim.api.nvim_create_augroup('LspConfig', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

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
    end

    -- Включаем Inlay Hints по умолчанию
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true)
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

-- Сочетания можно объявить глобально, привязывать их к буферу не имеет смысла
vim.keymap.set(
  'i',
  '<C-Space>',
  vim.lsp.completion.get,
  { desc = 'Trigger Completion' }
)

-- Неудобно тянуться до <C-y>
vim.keymap.set('i', '<cr>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<cr>'
end, { expr = true })
