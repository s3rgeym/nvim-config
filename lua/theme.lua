local theme_module = 'current-theme'
local theme_file = vim.fs.joinpath(
  vim.fn.stdpath('config'),
  'lua',
  theme_module
) .. '.lua'

local group = vim.api.nvim_create_augroup('ThemePersistence', { clear = true })

local function read_theme()
  -- сбрасываем кеш модуля, чтобы загрузилась его актуальная версия
  package.loaded[theme_module] = nil

  local ok, theme = pcall(require, theme_module)
  if ok and type(theme) == 'string' and theme ~= '' then
    return theme
  end
end

local function load_theme()
  local current_theme = read_theme()
  if current_theme then
    vim.cmd.colorscheme(current_theme)
  end
end

local function save_theme(theme_name)
  if not theme_name or theme_name == '' then
    return
  end

  local current_theme = read_theme()
  if theme_name == current_theme then
    return
  end

  local ok, res = pcall(vim.fn.writefile, {
    string.format('return %q', theme_name),
  }, theme_file)

  -- writefile при неудаче возвращает -1, а не бросает ошибку
  if not ok or res == -1 then
    vim.notify('Failed to save colorscheme', vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  desc = 'Save colorscheme',
  callback = function(args)
    save_theme(args.match)
  end,
})

-- Тему нужно применить после загрузки плагинов
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  once = true,
  -- Тут vim.cmd.colorscheme внутри load_theme вызывает
  -- события ColorScheme и ColorSchemePre, которые не будут перехвачены без
  -- nested
  nested = true,
  desc = 'Load colorscheme',
  callback = load_theme,
})
