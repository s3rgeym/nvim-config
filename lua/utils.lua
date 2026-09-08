local M = {}

function M.is_empty(s)
  return s == nil or s == ''
end

function M.gh(x)
  return 'https://github.com/' .. x
end

function M.pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

function M.feedkeys(keys, mode)
  local termocodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(termocodes, mode or 'n', true)
end

return M
