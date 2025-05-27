local M = {}

function M.map(mode, lhs, rhs, desc, opts)
  -- :h vim.keymap.set()
  opts = vim.tbl_extend('force', { silent = true, noremap = true }, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
