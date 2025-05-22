map({ 'n', 'i' }, '<C-a>', '<Esc>ggVG', { desc = "Select entire buffer" })

map('n', '<C-q>', '<cmd>q<CR>', { desc = "Close window" })
map('n', '<C-x>', '<cmd>bd<CR>', { desc = "Close buffer" })

-- <C-s> is already used in Neovim
-- map('', '<C-s>', '<cmd>w<CR>', { desc = "Save file" })
map('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })

map('n', '<Tab>', '>>_', { desc = "Indent line" })
map('n', '<S-Tab>', '<<_', { desc = "Unindent line" })
map('i', '<S-Tab>', '<C-D>', { desc = "Unindent" })
map('v', '<Tab>', '>gv', { desc = "Indent selection" })
map('v', '<S-Tab>', '<gv', { desc = "Unindent selection" })

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

map("i", "<C-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<C-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map('n', '<leader><CR>', '<cmd>split<CR>', { desc = "Horizontal split" })
map('n', '<leader>v', '<cmd>vsplit<CR>', { desc = "Vertical split" })

map('n', '<leader>ev', '<cmd>edit $MYVIMRC<CR>', { desc = "Edit config" })
map('n', '<leader>.', '<cmd>luafile $MYVIMRC<CR>', { desc = "Reload config" })

map({ 'n', 'i' }, '<F2>', "<cmd>setlocal spell!<cr>", { desc = "Toggle spellcheck" })

map("n", "<C-`>", "<cmd>split | terminal", { desc = "Open terminal", silent = true })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Focus left" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Focus down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Focus up" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Focus right" })

map("i", "<C-/>", "<C-o>gc<CR>", { desc = "Toggle comment", silent = true })
