local autocmd = vim.api.nvim_create_autocmd

-- Автоперечтение файла при изменении
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Восстановление последней позиции курсора при открытии файла
autocmd("BufReadPost", {
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
autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ChangeDirOnStartup", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end,
})

-- Автоматическое форматирование
autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format {
      async = false
    }
  end,
})

-- Показывать сообщения диагностики в всплывающем окне при наведении курсора
-- autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focus = false })
--   end
-- })
--
