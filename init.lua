local utils = require("user.utils")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Установка lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Клавишу leader надо объявить до загрузки плагинов lazy
vim.g.mapleader = ' '

-- Некоторые плагины могут неправильно работать, если не установить это значение
if utils.is_truecolor_supported() then
  vim.opt.termguicolors = true
end

-- Загрузка плагинов
require("lazy").setup("user.plugins")

-- Настройки должны идти после плагинов
require("user.options")
require("user.keymaps")
require("user.autocmds")
