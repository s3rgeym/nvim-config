local M = {}

function M.keymap(lhs, rhs, desc, mode)
  vim.keymap.set(mode or 'm', lhs, rhs, { desc = desc })
end

return M
