local theme_module = 'current-theme'
local theme_file = vim.fs.joinpath(
  vim.fn.stdpath('config'),
  'lua',
  theme_module
) .. '.lua'

local function save_theme(theme_name)
  local ok, err = pcall(vim.fn.writefile, {
    string.format('return %q', theme_name),
  }, theme_file)

  if not ok then
    vim.notify(
      'Failed to persist colorscheme: ' .. tostring(err),
      vim.log.levels.WARN
    )
  end
end

local function load_theme()
  package.loaded[theme_module] = nil -- отключаем кеширование модуля

  local ok, theme = pcall(require, theme_module)
  
  if ok and type(theme) == 'string' and theme ~= '' then
    pcall(vim.cmd.colorscheme, theme)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  desc = 'Save the current colorscheme',
  callback = function(args)
    if args.match and args.match ~= '' then
      save_theme(args.match)
    end
  end,
})

-- Тему нужно применить после загрузки плагинов
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Load the saved colorscheme',
  callback = load_theme,
})

