-- These are the core keybindings; others are scattered across plugins, etc.
local map = require("user.utils").map

-- General Commands
map('<leader>q', '<cmd>q<CR>', "Quit window")
map('<leader>w', '<cmd>write<CR>', "Write file")
map('<C-a>', 'ggVG', "Select entire buffer")
map('<Esc>', '<cmd>nohlsearch<CR>', "Clear search highlight")

-- Indentation
map('<S-Tab>', '<C-D>', "Unindent current line", 'i')
map('<Tab>', '>gv', "Indent selection", 'v')
map('<S-Tab>', '<gv', "Unindent selection", 'v')

-- Window Navigation (Splits)
map('<C-h>', '<C-w>h', "Go to left window")
map('<C-j>', '<C-w>j', "Go to window below")
map('<C-k>', '<C-w>k', "Go to window above")
map('<C-l>', '<C-w>l', "Go to right window")

-- Cycle through windows
map('<Tab>', '<C-w>w', "Go to next window")
map('<S-Tab>', '<C-w>W', "Go to previous window")

-- Resize Windows
map('<A-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('<A-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
map('<A-Down>', '<cmd>resize -2<CR>', "Decrease height")
map('<A-Up>', '<cmd>resize +2<CR>', "Increase height")

-- Buffer Navigation
map("<C-Left>", "<cmd>bp<CR>", "Previous buffer")
map("<C-Right>", "<cmd>bn<CR>", "Next buffer")

-- Move Lines
map("<C-Up>", ":m '<-2<CR>gv=gv", "Move selection up", 'v')
map("<C-Down>", ":m '>+1<CR>gv=gv", "Move selection down", 'v')
map("<C-Up>", "<Esc>:m .-2<CR>==gi", "Move line up", 'i')
map("<C-Down>", "<Esc>:m .+1<CR>==gi", "Move line down", 'i')

-- Split Window Creation
map('<leader>hs', '<cmd>split<CR>', "Horizontal split")
map('<leader>vs', '<cmd>vsplit<CR>', "Vertical split")

-- Config Management
map('<leader>ev', '<cmd>edit $MYVIMRC<CR>', "Edit NeoVim config")
map('<leader>sv', '<cmd>source $MYVIMRC<CR>', "Reload NeoVim config")

-- Spellcheck Toggle
map('<leader>sp', "<cmd>setlocal spell!<cr>", "Toggle spellcheck")

-- Terminal Keybindings
map("<leader>t", "<cmd>split | terminal<CR>", "Open terminal in horizontal split")
map("<Esc>", "<C-\\><C-n>", "Exit terminal mode", "t")
map("<C-h>", "<C-\\><C-n><C-w>h", "Exit terminal to left window", "t")
map("<C-j>", "<C-\\><C-n><C-w>j", "Exit terminal to window below", "t")
map("<C-k>", "<C-\\><C-n><C-w>k", "Exit terminal to window above", "t")
map("<C-l>", "<C-\\><C-n><C-w>l", "Exit terminal to right window", "t")
