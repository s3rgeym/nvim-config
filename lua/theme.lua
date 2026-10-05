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
  -- гарантируем загрузку новой версии модуля, а не кешированной версии
  package.loaded[theme_module] = nil

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
    if args.match and args.match ~= '' then
      save_theme(args.match)
    end
  end,
})

-- Тему нужно применить после загрузки плагинов
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Load the saved colorscheme',
  callback = function()
    -- Так видно как применяется тема
    -- Дополнительно выполним загрузку после всех обработчиков VimEnter
    -- vim.schedule(load_theme)
    load_theme()
  end,
})
