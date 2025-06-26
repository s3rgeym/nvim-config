local M = {}

function M.keymap(lhs, rhs, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

return M
