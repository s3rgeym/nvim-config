local M = {}

function M.map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.nmap(lhs, rhs, desc, opts)
  M.map('n', lhs, rhs, desc, opts)
end

function M.imap(lhs, rhs, desc, opts)
  M.map('i', lhs, rhs, desc, opts)
end

function M.vmap(lhs, rhs, desc, opts)
  M.map('v', lhs, rhs, desc, opts)
end

function M.tmap(lhs, rhs, desc, opts)
  M.map('t', lhs, rhs, desc, opts)
end

return M
