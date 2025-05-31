local M = {}

function M.is_truecolor_supported()
  -- Эта фича ровным счетом ничего не говорит
  -- if vim.fn.has('termguicolors') == 1 then
  --   return true
  -- end
  if vim.fn.has("gui_running") == 1 then
    return true
  end
  local colorterm = os.getenv("COLORTERM")
  if colorterm and colorterm:match("truecolor|24bit") then
    return true
  end
  local result = vim.fn.system('tput colors 2>/dev/null')
  return (tonumber(vim.fn.trim(result)) or 0) >= 256
end

function M.map(mode, lhs, rhs, desc, opts)
  -- :h vim.keymap.set()
  opts = vim.tbl_extend('force', { silent = true, noremap = true }, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
