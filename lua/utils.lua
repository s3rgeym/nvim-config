local M = {}

-- Имя модуля конфигурации темы
local theme_module = 'current-theme'

-- Путь к файлу конфигурации темы
local theme_file = vim.fn.stdpath('config') .. '/lua/' .. theme_module .. '.lua'

-- Функция загрузки сохраненной темы
function M.load_theme()
  -- Сбрасываем кэш require, чтобы всегда читать актуальный файл
  package.loaded[theme_module] = nil

  local ok, theme = pcall(require, theme_module)

  if ok and type(theme) == 'string' then
    pcall(vim.cmd.colorscheme, theme)
  end
end

-- Функция сохранения темы в файл
function M.save_theme(theme_name)
  local f = assert(io.open(theme_file, 'w'))
  f:write(string.format('return %q\n', theme_name))
  f:close()
end

return M
