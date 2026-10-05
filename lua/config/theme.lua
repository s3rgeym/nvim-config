local theme_module = 'config.current-theme'
local theme_file = vim.fs.joinpath(
  vim.fn.stdpath('config'),
  'lua',
  unpack(vim.split(theme_module, '.', { plain = true }))
) .. '.lua'

local function save_theme(name)
  if not name or name == '' then
    return
  end

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

local function load_theme()
  package.loaded[theme_module] = nil -- reload the module from disk

  local ok, theme = pcall(require, theme_module)
  if ok and type(theme) == 'string' and theme ~= '' then
    pcall(vim.cmd.colorscheme, theme)
  end
end

local group = vim.api.nvim_create_augroup('ThemePersistence', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  desc = 'Save the current colorscheme',
  callback = function(args)
    save_theme(args.match)
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Load the saved colorscheme',
  callback = load_theme,
})
