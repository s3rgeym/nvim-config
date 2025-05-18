local M = {}

-- Универсальная функция для биндингов
function M.map(mode, keys, command, desc, bufnr)
  local opts = { desc = desc, silent = true }
  if bufnr then
    opts.buffer = bufnr
  end
  vim.keymap.set(mode, keys, command, opts)
end

return M
