local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Эта настройка отвечает за изменение имен импортируемых файлов
-- По умолчанию она отключена
-- Эту настройку мало включить, нужно еще настроить файловый менеджер чтобы он
-- регистрировал событие после чего LSP запустит переименование, если он,
-- конечно, поддерживает его
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- Настройки для всех серверов
-- Эти настройки лишь сохранятсяб а применены они будут только при подключении к
-- LSP-серверу
vim.lsp.config('*', { capabilities = capabilities })

-- Многие отключают подсветку semantic tokens, т.к. за подсветку отвечает
-- treesitter, но я так и не понял, чем она мешает
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
vim.lsp.semantic_tokens.enable(false)

-- Уровень логирования
vim.lsp.log.set_level('WARN')

-- ========================= LSP-серверы =========================
-- Сами настройки задаются плагином nvim-lspconfig и переопределяются в
-- <rtp>/after/lsp

vim.lsp.enable({
  -- sudo pacman -S lua-language-server stylua
  'lua_ls',
  'stylua',

  -- sudo pacman -S vim-language-server
  'vimls',

  -- sudo pacman -S vscode-html-languageserver
  'html',

  -- sudo pacman -S vscode-json-languageserver
  'jsonls',

  -- sudo pacman -S vscode-css-languageserver
  'cssls',

  -- sudo pacman -S yaml-language-server
  'yamlls',

  -- sudo pacman -S typescript-language-server
  'ts_ls',

  -- sudo pacman -S vue-language-server
  'vue_ls',

  -- sudo pacman -S bash-language-server
  'bashls',

  -- sudo pacman -S dockerfile-language-server
  'dockerls',

  -- sudo pacman -S biome
  -- 'biome',

  -- sudo pacman -S tombi
  'tombi',

  -- Быстрый, но не умеет править импорты после переименования файла
  -- sudo pacman -S ty
  'ty',

  -- sudo pacman -S pyrefly
  -- 'pyrefly',

  -- sudo pacman -S basedpyright
  -- 'basedpyright',

  -- sudo pacman -S ruff
  -- Добавляет code actions
  'ruff',

  -- sudo pacman -S gopls
  'gopls',

  -- sudo pacman -S rust-analyzer
  'rust_analyzer',

  -- sudo pacman -S composer
  -- composer global require -W phpactor/phpactor
  'phpactor',
})

local lsp_group = vim.api.nvim_create_augroup('LspConfig', { clear = true })

local highlight_group = vim.api.nvim_create_augroup('LspHighlight', {
  clear = false,
})

-- Это сочетание всегда работает с текущим буфером
vim.keymap.set('n', '<leader>oi', function()
  vim.lsp.buf.code_action({
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
    apply = true,
  })
end, { desc = 'Organize imports' })

-- https://mintlify.wiki/neovim/neovim/lsp/completion
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local function bufmap(modes, lhs, rhs, opts)
      local options = type(opts) == 'string' and { desc = opts } or opts or {}
      options = vim.tbl_extend('force', {
        buffer = bufnr,
        silent = true,
      }, options)
      vim.keymap.set(modes, lhs, rhs, options)
    end

    -- Сочетания вынесем за блоки с проверками чтобы во всех буферах те были доступны
    -- Об <C-x><C-o> пальцы сломаешь
    bufmap('i', '<C-Space>', vim.lsp.completion.get, 'Trigger Completion')

    -- Сочетания для диагностики и нач-ся с gr заданы по умолчанию
    -- Эти сочетания по умолчанию не связаны с LSP
    bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
    bufmap('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')

    -- Показать сигнатуру функции
    -- На <c-s> уже висит
    -- map('i', '<c-k>', vim.lsp.buf.signature_help, 'Signature Help')

    -- Подтверждение выбора по Enter, так как неудобно тянуться до <C-y>
    bufmap('i', '<cr>', function()
      return vim.fn.pumvisible() == 1 and '<C-y>' or '<cr>'
    end, { expr = true })

    -- <C-n> назначать не надо, так как он и так служит для вызова дополнения
    -- keyword, если меню дополнения не открыто?

    -- Выбор вариантов по Tab и Shift-Tab
    bufmap('i', '<Tab>', function()
      return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
    end, { expr = true })

    -- Если на <S-Tab> в режиме редактирования повесить <C-d>, то он перестанет
    -- работать из-за этого сочетания. Я даже через feedkeys пробовал. Что-то не
    -- работает... Проблема тут в том еще, что <cr>, <Tab> в режиме вставки
    -- добавляют символы (пусть и непечатные), и никто их переопределять не
    -- станет
    bufmap('i', '<S-Tab>', function()
      return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
    end, { expr = true })

    bufmap('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, 'Toggle Inlay Hints')

    -- По умолчанию автодополнение вызывается при вводе ".", но это не очень
    -- удобно, привычнее когда варианты автоподстановки показываются, когда
    -- начинаешь печатать имя класса.
    if client:supports_method('textDocument/completion') then
      local chars = { '.', '_' }

      for i = 0, 61 do
        local base = i < 10 and 48 or i < 36 and 55 or 61 -- 0-9, A-Z, a-z
        table.insert(chars, string.char(base + i))
      end

      -- Символы эти можно так посмотреть
      -- :lua =vim.lsp.get_clients({ bufnr = 0 })[1].server_capabilities.completionProvider.triggerCharacters
      -- `:lua =` - это краткая запись для `:lua vim.print(...)`
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- Включаем Inlay Hints по умолчанию
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
