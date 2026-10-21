-- Настройки самих плагинов лежат в after/plugin/ и загружаются стандартным
-- механизмом Neovim
-- Пробуем включить новый интерфейс
pcall(function()
  require('vim._core.ui2').enable()
end)

-- Порядок подключения конфигов имеет значение
-- Ну, по крайней мере, options должны быть первыми
for _, name in ipairs({
  'options',
  'keymaps',
  'autocmds',
  'theme-persistence',
  'statusline',
  'diagnostics',
}) do
  require('config.' .. name)
end
