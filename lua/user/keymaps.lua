-- Тут находятся только базовые сочетания, остальные разбросаны по плагинам и тп
local map = require("user.utils").map

map('<leader>q', '<cmd>q<CR>', "Quit window")
map('<leader>w', '<cmd>write<CR>', "Write file")

map('<C-a>', 'ggVG', "Select entire buffer")

-- Переключение между буферами
map('<Tab>', '<cmd>bn<CR>', "Next buffer")
map('<S-Tab>', '<cmd>bp<CR>', "Previous buffer")

-- Работа с отступами
map('<S-Tab>', '<C-D>', "Unindent", 'i')
map('<Tab>', '>gv', "Indent selection", 'v')
map('<S-Tab>', '<gv', "Unindent selection", 'v')

-- Esc вроде в нормальном режиме и так не работает
map('<Esc>', '<cmd>nohlsearch<CR>', "Clear search highlight")

-- Стандартное перемещение между окнами
map('<C-h>', '<C-w>h', "Go to left window")
map('<C-j>', '<C-w>j', "Go to window below")
map('<C-k>', '<C-w>k', "Go to window above")
map('<C-l>', '<C-w>l', "Go to right window")

-- Изменение размеров
map('<A-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('<A-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
map('<A-Down>', '<cmd>resize -2<CR>', "Decrease height")
map('<A-Up>', '<cmd>resize +2<CR>', "Increase height")

-- Перемещение строк
map("<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down", 'i')
map("<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up", 'i')
map("J", ":m '>+1<CR>gv=gv", "Move selection down", 'v')
map("K", ":m '<-2<CR>gv=gv", "Move selection up", 'v')

-- Разбиение окон
map('<leader>hs', '<cmd>split<CR>', "Horizontal split")
map('<leader>vs', '<cmd>vsplit<CR>', "Vertical split")

-- Работа с конфигом
map('<leader>ev', '<cmd>edit $MYVIMRC<CR>', "Edit Neo[v]im config")
-- lazy.nvim все равно не поддерживает полную перезагрузку плагинов
map('<leader>sv', '<cmd>source $MYVIMRC<CR>', "Source Neo[v]im config")

-- Spellcheck. Нужен ли?
map('<leader>sp', "<cmd>setlocal spell!<cr>", "Toggle spellcheck")

-- Сочетания для терминала
map("<leader>t", "<cmd>split | terminal<CR>", "Open terminal")
map("<Esc>", "<C-\\><C-n>", "Escape terminal", "t")
map("<C-h>", "<C-\\><C-n><C-w>h", "Escape terminal to left window", "t")
map("<C-j>", "<C-\\><C-n><C-w>j", "Escape terminal to below window", "t")
map("<C-k>", "<C-\\><C-n><C-w>k", "Escape terminal to above window", "t")
map("<C-l>", "<C-\\><C-n><C-w>l", "Escape terminal to right window", "t")
