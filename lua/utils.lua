local M = {}

function M.feedkeys(keys)
  local termocodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(termocodes, 'n', true)
end

return M
