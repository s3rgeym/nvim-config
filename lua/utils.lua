local M = {}

local theme_module = 'current-theme'
local theme_file = vim.fs.joinpath(
  vim.fn.stdpath('config'),
  'lua',
  theme_module
) .. '.lua'

function M.save_theme(name)
  local ok, err = pcall(vim.fn.writefile, {
    string.format('return %q', name),
  }, theme_file)

  if not ok then
    vim.notify(
      'Failed to persist colorscheme: ' .. tostring(err),
      vim.log.levels.WARN
    )
  end
end

function M.load_theme()
  package.loaded[theme_module] = nil -- reload the module from disk

  local ok, theme = pcall(require, theme_module)
  if ok and type(theme) == 'string' and theme ~= '' then
    pcall(vim.cmd.colorscheme, theme)
  end
end

return M
