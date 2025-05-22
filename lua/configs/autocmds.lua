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

-- Открываем терминал в режиме вставки
vim.cmd [[autocmd TermOpen * startinsert]]
