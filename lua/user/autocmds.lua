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
      vim.cmd [[normal! g`"]]
    end
  end
})

-- Открываем терминал в режиме вставки
vim.cmd("autocmd TermOpen * startinsert")

-- Меняем рабочий каталог при запуске nvim
autocmd("VimEnter", {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.api.nvim_set_current_dir(data.file)
    end
  end,
})

-- Автоматическое форматирование при сохранении
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

-- Автоматическое сохранение и восстановление сессии
-- https://aymanbagabas.com/blog/2023/04/13/simple-vim-session-management.html
-- Удалил код из примера, так как он конфликтует с neotree
