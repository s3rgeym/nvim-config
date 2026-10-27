-- Настройки самих плагинов лежат в after/plugin/ и загружаются стандартным
-- механизмом Neovim
-- Пробуем включить новый интерфейс
pcall(function()
  require('vim._core.ui2').enable()
end)

-- Порядок подключения конфигов имеет значение
-- Задает leader и базовые настройки, поэтому должен идти первым
require('config.options')
-- Все модули, задающие сочтениния, быть загружены после задания клавиши Leader
require('config.diagnostics')
require('config.lsp')
require('config.theme-persistence')
require('config.statusline')
require('config.commands')
require('config.keymaps')
-- Должна быть загружена после темы, но у меня тема через событие ставится,
-- поэтому порядок не важен
require('config.autocmds')
