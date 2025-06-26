-- Тут находятся только базовые сочетания, остальные разбросаны по плагинам и тп
local map = require("user.utils").keymap

map('<leader>q', '<cmd>q<CR>', "Quit window")
-- Тут такая странная конструкция, чтобы избежать закрытия nvim, если нет
-- измененных буферов
map('<leader>x', '<cmd>b#<bar>bd#<CR>', "Close buffer")
map('<leader>w', '<cmd>write<CR>', "Write file")

map('<C-a>', '<Esc>ggVG', "Select entire buffer", { 'n', 'i' })

map('<A-Left>', '<cmd>bp<CR>', "Previous buffer")
map('<A-Right>', '<cmd>bn<CR>', "Next buffer")

map('<A-Up>', '<cmd>tabprev<CR>', "Previous tab")
map('<A-Down>', '<cmd>tabnext<CR>', "Next tab")

-- Работа с отступами
map('<Tab>', '>>_', "Indent")
map('<S-Tab>', '<<_', "Unindent")
map('<S-Tab>', '<C-D>', "Unindent", 'i')
map('<Tab>', '>gv', "Indent selection", 'v')
map('<S-Tab>', '<gv', "Unindent selection", 'v')

map('<Esc>', '<cmd>nohlsearch<CR><Esc>', "Clear search highlight")

map('<C-h>', '<C-w>h', "Go to left window")
map('<C-j>', '<C-w>j', "Go to window below")
map('<C-k>', '<C-w>k', "Go to window above")
map('<C-l>', '<C-w>l', "Go to right window")

map('<A-h>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('<A-l>', '<cmd>vertical resize +2<CR>', "Increase width")
map('<A-j>', '<cmd>resize -2<CR>', "Decrease height")
map('<A-k>', '<cmd>resize +2<CR>', "Increase height")

map("<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down", 'i')
map("<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up", 'i')
map("J", ":m '>+1<CR>gv=gv", "Move selection down", 'v')
map("K", ":m '<-2<CR>gv=gv", "Move selection up", 'v')

map('<leader>sh', '<cmd>split<CR>', "Horizontal split")
map('<leader>sv', '<cmd>vsplit<CR>', "Vertical split")

map('<leader>ev', '<cmd>split $MYVIMRC<CR>', "Edit Neovim config")
-- lazy.nvim все равно не поддерживает перезагрузку конфига
-- map('<leader>rv', utils.reload_nvim_config, "Reload Neovim config")

map('<leader>sp', "<cmd>setlocal spell!<cr>", "Toggle spellcheck")

map("<leader>t", "<cmd>split | terminal<CR>", "Open terminal")
map("<Esc>", "<C-\\><C-n>", "Escape terminal", "t")
map("<C-h>", "<C-\\><C-n><C-w>h", "Escape terminal to left window", "t")
map("<C-j>", "<C-\\><C-n><C-w>j", "Escape terminal to below window", "t")
map("<C-k>", "<C-\\><C-n><C-w>k", "Escape terminal to above window", "t")
map("<C-l>", "<C-\\><C-n><C-w>l", "Escape terminal to right window", "t")
