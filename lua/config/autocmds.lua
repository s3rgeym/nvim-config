---@diagnostic disable: undefined-field
local group = vim.api.nvim_create_augroup('UserAutocmds', { clear = true })

-- Чтобы вручную не вводить :e!
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  group = group,
  desc = 'Check for external file changes',
  command = "if mode() != 'c' | checktime | endif",
})

-- Настройки форматирования можно переопределить в plugin/*.lua, но так
-- универсальнее
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = group,
  desc = 'Set buffer format options',
  callback = function()
    -- По дефолту что-то типа ljcqrt.
    vim.opt_local.formatoptions = { c = true, j = true, q = true }
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  desc = 'Restore cursor position',
  callback = function(ev)
    local row, col = unpack(vim.api.nvim_buf_get_mark(ev.buf, '"'))
    if row > 0 and row <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = group,
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

vim.api.nvim_create_autocmd('VimResized', {
  group = group,
  desc = 'Equalize window splits',
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Я встроенным терминалом не пользуюсь
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = group,
--   desc = 'Start terminal in insert mode',
--   command = "startinsert",
-- })

-- Глобально word wrap отключен, но в некоторых текстовых форматах без него
-- сложно
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'markdown', 'text', 'gitcommit' },
  desc = 'Enable wrapping for text files',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
  end,
})
