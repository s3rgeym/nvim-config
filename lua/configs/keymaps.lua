local map = require("utils").map

vim.g.mapleader = ' '

map('n', '<C-a>', 'ggVG', "Select all text")
map('i', '<C-a>', '<Esc>ggVG', "Select all text")

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

map('n', '<C-Up>', '<cmd>bp<CR>', "Previous buffer")
map('n', '<C-Down>', '<cmd>bn<CR>', "Next buffer")

map('n', '<C-h>', '<C-w>h', "Focus left window")
map('n', '<C-j>', '<C-w>j', "Focus lower window")
map('n', '<C-k>', '<C-w>k', "Focus upper window")
map('n', '<C-l>', '<C-w>l', "Focus right window")

map('n', '<A-h>', '<C-w>H', "Move window left")
map('n', '<A-j>', '<C-w>J', "Move window down")
map('n', '<A-k>', '<C-w>K', "Move window up")
map('n', '<A-l>', '<C-w>L', "Move window right")

map('n', '<A-Left>', '<cmd>vertical resize -2<CR>', "Decrease width")
map('n', '<A-Right>', '<cmd>vertical resize +2<CR>', "Increase width")
map('n', '<A-Down>', '<cmd>resize -2<CR>', "Decrease height")
map('n', '<A-Up>', '<cmd>resize +2<CR>', "Increase height")

map('v', "J", ":m '>+1<CR>gv=gv", "Shift visual selected line down")
map('v', "K", ":m '<-2<CR>gv=gv", "Shift visual selected line up")

map('n', '<leader>h', '<cmd>split<CR>', "Horizontal split")
map('n', '<leader>v', '<cmd>vsplit<CR>', "Vertical split")

-- nvim автоматически добавляет переменную $MYVIMRC, ее не нужно добавлять
map('n', '<leader>ev', '<cmd>edit $MYVIMRC<CR>', "Edit vim config")
map('n', '<leader>sv', '<cmd>so $MYVIMRC<CR>', "Reload vim config")

-- F3-F11 лучше оставить для дебаггера
map('', '<F2>', ":setlocal spell!<cr>", "Toggle spell check")

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", "find file")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Find [using] grep")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", "find buffer")

-- Можно использовать любое из сочетаний с Ctrl+T/N/P, так как на них навешен бесполезный функционал
map("n", "<C-t>", "<cmd>NvimTreeToggle<CR>", "Toggle nvim tree")

-- Можно через telescope тоже самое делать
local setup_lsp_keymaps = function(_, bufnr)
  map("n", "gd", vim.lsp.buf.definition, "Go to definition", bufnr)
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration", bufnr)
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation", bufnr)
  map("n", "gr", vim.lsp.buf.references, "List references", bufnr)
  map("n", "K", vim.lsp.buf.hover, "Hover documentation", bufnr)
  -- На эту клавишу в режиме редактирования по умолчанию уже задано это действие
  map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help", bufnr)
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol", bufnr)
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action", bufnr)
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic", bufnr)
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic", bufnr)
  map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostics", bufnr)
end

return {
  setup_lsp_keymaps = setup_lsp_keymaps
}
