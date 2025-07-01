-- These are the core keybindings; others are scattered across plugins, etc.
local utils = require("user.utils")

-- "Destructure" the mapping functions for direct use
local nmap = utils.nmap
local imap = utils.imap
local vmap = utils.vmap
local tmap = utils.tmap

-- General Commands
nmap('<leader>q', '<cmd>q<CR>', "Quit window")
nmap('<leader>w', '<cmd>write<CR>', "Write file")
nmap('<C-a>', 'ggVG', "Select entire buffer")
nmap('<Esc>', '<cmd>nohlsearch<CR>', "Clear search highlight")

-- Indentation
imap('<S-Tab>', '<C-D>', "Unindent current line")
vmap('<Tab>', '>gv', "Indent selection")
vmap('<S-Tab>', '<gv', "Unindent selection")

-- Window Navigation (Splits)
nmap('<C-h>', '<C-w>h', "Go to left window")
nmap('<C-j>', '<C-w>j', "Go to window below")
nmap('<C-k>', '<C-w>k', "Go to window above")
nmap('<C-l>', '<C-w>l', "Go to right window")

-- Cycle through windows
nmap('<Tab>', '<C-w>w', "Go to next window")
nmap('<S-Tab>', '<C-w>W', "Go to previous window")

-- Resize Windows
nmap('<A-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
nmap('<A-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
nmap('<A-Down>', '<cmd>resize -2<CR>', "Decrease height")
nmap('<A-Up>', '<cmd>resize +2<CR>', "Increase height")

-- Buffer Navigation
nmap("<C-Left>", "<cmd>bp<CR>", "Previous buffer")
nmap("<C-Right>", "<cmd>bn<CR>", "Next buffer")

-- Move Lines
vmap("<C-Up>", ":m '<-2<CR>gv=gv", "Move selection up")
vmap("<C-Down>", ":m '>+1<CR>gv=gv", "Move selection down")
imap("<C-Up>", "<Esc>:m .-2<CR>==gi", "Move line up")
imap("<C-Down>", "<Esc>:m .+1<CR>==gi", "Move line down")

-- Split Window Creation
nmap('<leader>hs', '<cmd>split<CR>', "Horizontal split")
nmap('<leader>vs', '<cmd>vsplit<CR>', "Vertical split")

-- Config Management
nmap('<leader>ev', '<cmd>edit $MYVIMRC<CR>', "Edit NeoVim config")
nmap('<leader>sv', '<cmd>source $MYVIMRC<CR>', "Reload NeoVim config")

-- Spellcheck Toggle
nmap('<leader>sp', "<cmd>setlocal spell!<cr>", "Toggle spellcheck")

-- Terminal Keybindings
nmap("<leader>t", "<cmd>split | terminal<CR>", "Open terminal in horizontal split")
tmap("<Esc>", "<C-\\><C-n>", "Exit terminal mode")
tmap("<C-h>", "<C-\\><C-n><C-w>h", "Exit terminal to left window")
tmap("<C-j>", "<C-\\><C-n><C-w>j", "Exit terminal to window below")
tmap("<C-k>", "<C-\\><C-n><C-w>k", "Exit terminal to window above")
tmap("<C-l>", "<C-\\><C-n><C-w>l", "Exit terminal to right window")
