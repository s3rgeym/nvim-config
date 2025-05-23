-- Автоперечтение файла при изменении
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Форматирование при сохранении
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format {
      async = false
    }
  end,
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
vim.cmd [[autocmd TermOpen * startinsert]]
