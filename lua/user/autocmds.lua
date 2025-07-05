-- Автоперечтение файла при изменении
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Восстановление последней позиции курсора при открытии файла
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") >= 1 and vim.fn.line("'\"") <= vim.fn.line("$") and not vim.bo.filetype:match("commit") then
      vim.cmd([[normal! g`"]])
    end
  end
})

-- Открываем терминал в режиме вставки
vim.cmd("autocmd TermOpen * startinsert")

-- Меняем рабочий каталог при запуске nvim
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ChangeDirOnStartup", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end,
})

-- Отображает автоматически сообщения диагностики в всплывающем окне
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focus = false })
--   end
-- })
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function()
--     vim.lsp.buf.format {
--       async = false
--     }
--   end,
-- })
