-- Базовые сочетания

local map = require("utils").map

map({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', "Select all text")

map('n', '<C-q>', '<cmd>q<CR>', "Close current window")
map('n', '<C-x>', '<cmd>bd<CR>', "Delete current buffer")
-- В Neovim это сочетание уже используется
-- map('', '<C-s>', '<cmd>w<CR>', "Save file")
map('n', '<leader>w', '<cmd>w<CR>', "Save file")

-- Отступы привычнее добавлять с помощью Tab
map('n', '<Tab>', '>>_', "Increase indent")
map('n', '<S-Tab>', '<<_', "Decrease indent")
map('i', '<S-Tab>', '<C-D>', "Decrease indent")
map('v', '<Tab>', '>gv', "Increase indent")
map('v', '<S-Tab>', '<gv', "Decrease indent")

map('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', "Clear search highlight")

-- Можно на Ctrl-[ и Ctrl-] навесить — то же распространенное сочетание
map('n', '<C-Up>', '<cmd>bp<CR>', "Previous buffer")
map('n', '<C-Down>', '<cmd>bn<CR>', "Next buffer")

map('n', '<C-h>', '<C-w>h', "Focus left window")
map('n', '<C-j>', '<C-w>j', "Focus lower window")
map('n', '<C-k>', '<C-w>k', "Focus upper window")
map('n', '<C-l>', '<C-w>l', "Focus right window")

map('n', '<M-h>', '<C-w>H', "Move window left")
map('n', '<M-j>', '<C-w>J', "Move window down")
map('n', '<M-k>', '<C-w>K', "Move window up")
map('n', '<M-l>', '<C-w>L', "Move window right")

map('n', '<M-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('n', '<M-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
map('n', '<M-Down>', '<cmd>resize -2<CR>', "Decrease height")
map('n', '<M-Up>', '<cmd>resize +2<CR>', "Increase height")

map('v', "J", ":m '>+1<CR>gv=gv", "Shift visual selected line down")
map('v', "K", ":m '<-2<CR>gv=gv", "Shift visual selected line up")

map('n', '<leader>h', '<cmd>split<CR>', "Horizontal split")
map('n', '<leader>v', '<cmd>vsplit<CR>', "Vertical split")

-- nvim автоматически добавляет переменную $MYVIMRC, ее не нужно добавлять
map('n', '<leader>ev', '<cmd>edit $MYVIMRC<CR>', "Edit vim config")
map('n', '<leader>sv', '<cmd>so $MYVIMRC<CR>', "Reload vim config")

-- F3-F11 лучше оставить для дебаггера
map({ 'n', 'i' }, '<F2>', "<cmd>setlocal spell!<cr>", "Toggle spell check")
