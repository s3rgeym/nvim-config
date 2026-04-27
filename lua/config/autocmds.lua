---@diagnostic disable: undefined-field
local group = vim.api.nvim_create_augroup('User', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Restore session',
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.filereadable('Session.vim') == 1 then
      vim.cmd('silent source Session.vim')
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  desc = 'Session save',
  callback = function()
    if vim.v.this_session ~= '' then
      vim.cmd('mksession! ' .. vim.fn.fnameescape(vim.v.this_session))
    end
  end,
})

-- Из ChatGPT
vim.api.nvim_create_autocmd('BufReadPre', {
  callback = function(args)
    local stat = vim.loop.fs_stat(args.file)
    if stat and stat.size > 1024 * 1024 then
      vim.b.large_file = true
      vim.cmd('syntax off')
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    if vim.b.large_file then
      pcall(vim.treesitter.stop)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.json',
  desc = 'Enable json comments',
  callback = function()
    vim.bo.filetype = 'jsonc'
  end,
})

-- Чтобы вручную не вводить :e!
-- Я не уверен что тут нужен BufEnter
vim.api.nvim_create_autocmd(
  { 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' },
  {
    group = group,
    desc = 'Sync file changes',
    command = "if mode() != 'c' | checktime | endif",
  }
)

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = group,
  desc = 'Clear formatoptions',
  callback = function()
    -- По дефолту что-то типа ljcqrt
    vim.opt_local.formatoptions = { j = true, q = true }
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

-- vim.api.nvim_create_autocmd("BufReadCmd", {
--   group = aucmd_group,
--   pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
--   desc = "Open in external viewer",
--   command = "exe 'silent !display <afile> &' | b# | bw! #",
-- })

-- Мне оно больше мешает
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   group = group,
--   desc = 'Create missing directories',
--   callback = function(event)
--     -- Буферы с именами типа oil://
--     if event.match:match('^%w+://') then
--       return
--     end
--     local file = vim.uv.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
--   end,
-- })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  desc = "Close with 'q'",
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
--   desc = "Terminal insert mode",
--   command = "startinsert",
-- })
