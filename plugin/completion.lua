local feedkeys = require('utils').feedkeys

-- Неудобно, что при выборе части пути, его автодополнение завершается
vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    if
      vim.v.event.complete_type == 'files' and vim.v.event.reason == 'accept'
    then
      feedkeys('<C-x><C-f>')
    end
  end,
})
