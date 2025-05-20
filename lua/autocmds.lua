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

-- Показывать всплывающие окна с ошибками при наведении курсора
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focusable = false })
--   end,
-- })
