local M = {}

M.map = function(lhs, rhs, opts, mode)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  opts = vim.tbl_extend('force', { silent = true, noremap = true }, opts or {})
  vim.keymap.set(mode or 'n', lhs, rhs, opts)
end

return M
