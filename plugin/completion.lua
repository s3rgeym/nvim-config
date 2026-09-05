local feedkeys = require('utils').feedkeys

-- Неудобно, что при выборе части пути, его автодополнение завершается
vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    local e = vim.v.event
    if e.complete_type == 'files' and e.reason == 'accept' then
      feedkeys('<C-x><C-f>')
    end
  end,
})
