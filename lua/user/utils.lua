local M = {}

function M.map(lhs, rhs, desc, mode)
  vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc })
end

return M
