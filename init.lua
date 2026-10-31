-- Настройки самих плагинов лежат в after/plugin/ и загружаются стандартным
-- механизмом Neovim
-- Пробуем включить новый интерфейс
pcall(function()
  require('vim._core.ui2').enable()
end)

-- Порядок подключения конфигов имеет значение
-- Задает leader и базовые настройки, поэтому должен идти первым
require('core.options')
-- Все модули, задающие сочетания, быть загружены после задания клавиши Leader
require('core.diagnostics')
require('core.lsp')
require('core.theme-persistence')
require('core.statusline')
require('core.commands')
require('core.keymaps')
require('core.autocmds')
