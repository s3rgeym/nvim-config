-- Базовые сочетания
-- :h vim.keymap.set()
local map = vim.keymap.set

map({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', { desc = "Select all text" })

map('n', '<C-q>', '<cmd>q<CR>', { desc = "Close current window" })
map('n', '<C-x>', '<cmd>bd<CR>', { desc = "Delete current buffer" })
-- В Neovim это сочетание уже используется
--  map('', '<C-s>', '<cmd>w<CR>', { desc = "Save file" })
map('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })

-- Отступы привычнее добавлять с помощью Tab
map('n', '<Tab>', '>>_', { desc = "Increase indent" })
map('n', '<S-Tab>', '<<_', { desc = "Decrease indent" })
map('i', '<S-Tab>', '<C-D>', { desc = "Decrease indent" })
map('v', '<Tab>', '>gv', { desc = "Increase indent" })
map('v', '<S-Tab>', '<gv', { desc = "Decrease indent" })

map('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = "Clear search highlight" })

map('n', '<S-h>', '<cmd>bp<CR>', { desc = "Previous buffer" })
map('n', '<S-l>', '<cmd>bn<CR>', { desc = "Next buffer" })

map('n', '<C-h>', '<C-w>h', { desc = "Focus left" })
map('n', '<C-j>', '<C-w>j', { desc = "Focus down" })
map('n', '<C-k>', '<C-w>k', { desc = "Focus up" })
map('n', '<C-l>', '<C-w>l', { desc = "Focus right" })

map('n', '<M-h>', '<C-w>H', { desc = "Move window left" })
map('n', '<M-j>', '<C-w>J', { desc = "Move window down" })
map('n', '<M-k>', '<C-w>K', { desc = "Move window up" })
map('n', '<M-l>', '<C-w>L', { desc = "Move window right" })

map('n', '<M-Left>', '<cmd>vertical resize -2<CR>', { desc = "Decrease width" })
map('n', '<M-Right>', '<cmd>vertical resize +2<CR>', { desc = "Increase width" })
map('n', '<M-Down>', '<cmd>resize -2<CR>', { desc = "Decrease height" })
map('n', '<M-Up>', '<cmd>resize +2<CR>', { desc = "Increase height" })

map('i', "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map('i', "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map('v', "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map('v', "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

map("i", "<C-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<C-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map('n', '<leader><CR>', '<cmd>split<CR>', { desc = "Horizontal split" })
map('n', '<leader>v', '<cmd>vsplit<CR>', { desc = "Vertical split" })

-- nvim автоматически добавляет переменную $MYVIMRC, ее не нужно добавлять
map('n', '<leader>ev', '<cmd>edit $MYVIMRC<CR>', { desc = "Edit vim config" })
map('n', '<leader>.', '<cmd>luafile $MYVIMRC<CR>', { desc = "Reload vim config" })

-- F3-F11 лучше оставить для дебаггера
map({ 'n', 'i' }, '<F2>', "<cmd>setlocal spell!<cr>", { desc = "Toggle spell check" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move focus left" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move focus down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move focus up" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move focus right" })
