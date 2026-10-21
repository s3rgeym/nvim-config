-- Подсветка yank
local yank_group =
  vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- Позиция курсора
local cursor_group =
  vim.api.nvim_create_augroup('RestoreCursor', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = cursor_group,
  desc = 'Restore cursor position',
  callback = function(ev)
    local row, col = unpack(vim.api.nvim_buf_get_mark(ev.buf, '"'))
    if row > 0 and row <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    end
  end,
})

-- Служебные буферы
local special_group =
  vim.api.nvim_create_augroup('SpecialBuffers', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = special_group,
  desc = "Close special buffers with 'q'",
  pattern = { 'help', 'checkhealth', 'qf', 'man', 'lspinfo' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      'n',
      'q',
      '<cmd>close<CR>',
      { buffer = event.buf, silent = true }
    )
  end,
})

-- Внешние изменения файла
local checktime_group =
  vim.api.nvim_create_augroup('Checktime', { clear = true })

-- Чтобы вручную не вводить :e!
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  group = checktime_group,
  desc = 'Check for external file changes',
  command = "if mode() != 'c' | checktime | endif",
})

-- Размер окон
local resize_group =
  vim.api.nvim_create_augroup('ResizeSplits', { clear = true })

vim.api.nvim_create_autocmd('VimResized', {
  group = resize_group,
  desc = 'Equalize window splits',
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Большие файлы
-- Проверка, находясь в большом файле: :lua =vim.b.large_file
local large_group = vim.api.nvim_create_augroup('LargeFile', { clear = true })
local MAX_SIZE = 10 * 1024 * 1024 -- 10 МБ

vim.api.nvim_create_autocmd('BufReadPre', {
  group = large_group,
  desc = 'Detect large files',
  callback = function(ev)
    local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(ev.buf))
    if stat and stat.size > MAX_SIZE then
      vim.b[ev.buf].large_file = true
      vim.opt_local.swapfile = false
      vim.opt_local.undolevels = -1
      vim.opt_local.foldmethod = 'manual'
    end
  end,
})

-- BufWinEnter приходит после FileType, когда синтаксис и treesitter
-- уже включены другими, поэтому здесь их можно гарантированно выключить
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = large_group,
  desc = 'Disable highlighting for large files',
  callback = function(ev)
    if not vim.b[ev.buf].large_file then
      return
    end
    pcall(vim.treesitter.stop, ev.buf)
    vim.cmd('syntax clear')
    vim.opt_local.syntax = 'off'
    vim.opt_local.cursorline = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false
    vim.b[ev.buf].matchparen_disable = true
  end,
})

-- Перенос строк в текстовых форматах (зависит от LargeFile)
local wrap_group = vim.api.nvim_create_augroup('TextWrap', { clear = true })

-- Глобально word wrap отключен, но в некоторых текстовых форматах без него
-- сложно
vim.api.nvim_create_autocmd('FileType', {
  group = wrap_group,
  pattern = {
    'markdown',
    'text',
    'gitcommit',
    'rst',
    'asciidoc',
    'tex',
    'mail',
    'help',
  },
  desc = 'Enable wrapping for text files',
  callback = function(ev)
    if vim.b[ev.buf].large_file then
      return
    end
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
  end,
})

-- Format options
local formatoptions_group =
  vim.api.nvim_create_augroup('FormatOptions', { clear = true })

-- В арче настройки форматирования заданы где-то в /usr/share, и грузятся после
-- init.lua, поэтому их можно задать только через autocmd либо, кинув в plugin
vim.api.nvim_create_autocmd('FileType', {
  group = formatoptions_group,
  desc = 'Set format options',
  callback = function()
    -- По дефолту что-то типа ljcqrt.
    vim.opt_local.formatoptions = { c = true, j = true, q = true }
  end,
})

-- Терминал
-- local term_group =
--   vim.api.nvim_create_augroup('TerminalInsert', { clear = true })
--
-- vim.api.nvim_create_autocmd('TermOpen', {
--   group = term_group,
--   desc = 'Start terminal in insert mode',
--   command = 'startinsert',
-- })
