-- Настройки самих плагинов лежат в after/plugin/ и загружаются стандартным
-- механизмом Neovim
-- Пробуем включить новый интерфейс
pcall(function()
  require('vim._core.ui2').enable()
end)

-- Порядок подключения конфигов имеет значение
-- Ну, по крайней мере, options должнен быть первым,
-- а statusline идти после темы, так как берет из нее
-- цвета highlight групп
-- При использовании циклов в файл по gf нельзя перейти
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.diagnostics')
require('core.theme-persistence')
require('core.statusline')
