local M = {}

-- Функция для установки биндингов
function M.map(mode, keys, command, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, keys, command, opts)
end

return M
