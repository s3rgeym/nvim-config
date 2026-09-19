vim.pack.add({
  -- Содержит список настроек языковых серверов, избавляя от необходимости все
  -- делать вручную
  'https://github.com/neovim/nvim-lspconfig',
  -- 'https://github.com/b0o/schemastore.nvim',
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Настройки для всех серверов
vim.lsp.config('*', { capabilities = capabilities })

-- Это нужно с biome подружить
-- Специфичные настройки jsonls
-- vim.lsp.config('jsonls', {
--   settings = {
--     json = {
--       -- Дополнение в json через схемы
--       schemas = require('schemastore').json.schemas(),
--       validate = { enable = true },
--     },
--   },
-- })

-- Настройка внешнего вида диагностики
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
})

-- Показывать сообщение диагностики при наведении курсора
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- https://mintlify.wiki/neovim/neovim/lsp/completion
local lsp_group = vim.api.nvim_create_augroup('LspConfig', { clear = true })
local highlight_group = vim.api.nvim_create_augroup('LspHighlight', {
  clear = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local function map(modes, lhs, rhs, opts)
      opts = type(opts) == 'string' and { desc = opts } or opts
      opts = vim.tbl_extend('force', {
        buffer = bufnr,
        silent = true,
      }, opts or {})
      vim.keymap.set(modes, lhs, rhs, opts)
    end

    -- Сочетания вынесем за блоки с проверками чтобы во всех буферах те были доступны
    -- Об <C-x><C-o> пальцы сломаешь
    map('i', '<C-Space>', vim.lsp.completion.get, 'Trigger Completion')

    -- Сочетания для диагностики и нач-ся с gr заданы по умолчанию
    -- Эти сочетания по умолчанию не связаны с LSP
    map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')

    -- Показать сигнатуру функции
    map('i', '<c-k>', vim.lsp.buf.signature_help, 'Signature Help')

    -- Подтверждение выбора по Enter, так как неудобно тянуться до <C-y>
    map('i', '<cr>', function()
      return vim.fn.pumvisible() == 1 and '<C-y>' or '<cr>'
    end, { expr = true })

    -- <C-n> назначать не надо, так как он и так служит для вызова дополнения
    -- keyword, если меню дополнения не открыто

    -- Выбор вариантов по Tab и Shift-Tab
    map('i', '<Tab>', function()
      return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
    end, { expr = true })

    -- Если на <S-Tab> в режиме редактирования повесить <C-d>, то он перестанет
    -- работать из-за этого сочетания. Я даже через feedkeys пробовал. Что-то не
    -- работает... Проблема тут в том еще, что <cr>, <Tab> в режиме вставки
    -- добавляют символы (пусть и непечатные), и никто их переопределять не
    -- станет
    map('i', '<S-Tab>', function()
      return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
    end, { expr = true })

    map('n', '<leader>i', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, 'Toggle [I]nlay Hints')

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
      vim.api.nvim_clear_autocmds({
        group = highlight_group,
        buffer = bufnr,
      })

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
