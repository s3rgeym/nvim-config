-- Настройки самих плагинов лежат в plugin/ и загружаются стандартным
-- механизмом Neovim
-- Пробуем включить новый интерфейс
pcall(function()
  require('vim._core.ui2').enable()
end)
require('config.options')
require('config.keymaps')
require('config.autocmds')
