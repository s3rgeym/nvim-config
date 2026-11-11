-- Идею я а блоге подсмотрел, но там в json-файл тема сохранялась
local theme_module = 'current-theme'
local theme_file = vim.fs.joinpath(
  vim.fn.stdpath('config'),
  'lua',
  theme_module
) .. '.lua'

local augroup =
  vim.api.nvim_create_augroup('ThemePersistence', { clear = true })

local function read_theme()
  -- сбрасываем кеш модуля, чтобы загрузилась его актуальная версия
  package.loaded[theme_module] = nil

  local ok, theme = pcall(require, theme_module)
  if ok and type(theme) == 'string' and theme ~= '' then
    return theme
  end
end

local function apply_theme()
  local theme = read_theme()
  if theme then
    pcall(vim.cmd.colorscheme, theme)
  end
end

local function write_theme(theme)
  if not theme or theme == '' then
    return
  end

  if theme == read_theme() then
    return
  end

  local ok, res = pcall(vim.fn.writefile, {
    string.format('return %q', theme),
  }, theme_file)

  if not ok or res == -1 then
    vim.notify('Failed to save colorscheme', vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  desc = 'Save colorscheme',
  callback = function(args)
    write_theme(args.match)
  end,
})

-- Тему нужно применить после загрузки плагинов
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  once = true,
  -- Тут vim.cmd.colorscheme внутри apply_theme вызывает
  -- события ColorScheme и ColorSchemePre, которые не будут перехвачены без
  -- nested
  nested = true,
  desc = 'Load colorscheme',
  callback = apply_theme,
})
