-- Тут находятся только базовые сочетания, остальные разбросаны по плагинам и тп
local map = require("user.utils").map

map('n', '<leader>q', '<cmd>q<CR>', "Quit window")
-- Тут такая странная конструкция, чтобы избежать закрытия nvim, если нет
-- измененных буферов
map('n', '<leader>x', '<cmd>b#<bar>bd#<CR>', "Close buffer")
map('n', '<leader>w', '<cmd>w<CR>', "Write file")

map({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', "Select entire buffer")

-- Добавлять отступы удобнее табом
map('n', '<Tab>', '>>_', "Indent line")
map('n', '<S-Tab>', '<<_', "Unindent line")
map('i', '<S-Tab>', '<C-D>', "Unindent")
map('v', '<Tab>', '>gv', "Indent selection")
map('v', '<S-Tab>', '<gv', "Unindent selection")

map('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', "Clear search highlight")

map('n', '<S-h>', '<cmd>bp<CR>', "Previous buffer")
map('n', '<S-l>', '<cmd>bn<CR>', "Next buffer")

map('n', '<C-h>', '<C-w>h', "Go to left window")
map('n', '<C-j>', '<C-w>j', "Go to window below")
map('n', '<C-k>', '<C-w>k', "Go to window above")
map('n', '<C-l>', '<C-w>l', "Go to right window")

map('n', '<M-h>', '<C-w>H', "Move window left")
map('n', '<M-j>', '<C-w>J', "Move window down")
map('n', '<M-k>', '<C-w>K', "Move window up")
map('n', '<M-l>', '<C-w>L', "Move window right")

map('n', '<M-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('n', '<M-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
map('n', '<M-Down>', '<cmd>resize -2<CR>', "Decrease height")
map('n', '<M-Up>', '<cmd>resize +2<CR>', "Increase height")

map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up")
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

map('n', '<leader><CR>', '<cmd>split<CR>', "Horizontal split")
map('n', '<leader>v', '<cmd>vsplit<CR>', "Vertical split")

map('n', '<leader>ev', '<cmd>split $MYVIMRC<CR>', "Edit Neovim config")
-- lazy.nvim все равно не поддерживает перезагрузку конфига
-- map('n', '<leader>rv', utils.reload_nvim_config, "Reload Neovim config")

map('n', '<leader>ss', "<cmd>setlocal spell!<cr>", "Toggle spellcheck")

map("n", "<leader>t", "<cmd>split | terminal<CR>", "Open terminal")
map("t", "<Esc>", "<C-\\><C-n>", "Escape terminal")
map("t", "<C-h>", "<C-\\><C-n><C-w>h", "Escape terminal to left window")
map("t", "<C-j>", "<C-\\><C-n><C-w>j", "Escape terminal to below window")
map("t", "<C-k>", "<C-\\><C-n><C-w>k", "Escape terminal to above window")
map("t", "<C-l>", "<C-\\><C-n><C-w>l", "Escape terminal to right window")
