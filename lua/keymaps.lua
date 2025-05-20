local map = require("utils").map

vim.g.mapleader = ' '

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
map({ 'n', 'i' }, '<F2>', ":setlocal spell!<cr>", "Toggle spell check")

map("n", "<leader>/", "<cmd>Telescope find_files<cr>", "Find file")
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", "Find using grep")
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", "Find buffer")

-- Можно использовать любое из сочетаний с Ctrl+T/N/P, так как на них навешен бесполезный функционал
-- Ctrl-T лучше не использовать для NvimTree
map("n", "<C-p>", "<cmd>NvimTreeToggle<CR>", "Toggle files panel")

-- Debugging
map("n", "<F5>", function() require('dap').continue() end, "Continue debug")
map("n", "<F10>", function() require('dap').cstep_over() end, "Debug: step over")
map("n", "<F11>", function() require('dap').step_into() end, "Debug: step into")
map("n", "<F12>", function() require('dap').step_out() end, "Debug: step out")
map("n", '<M-b>', function() require('dap').toggle_breakpoint() end, "Toggle beakpoint")
map({ "n", "v" }, '<M-e>', function() require('dapui').eval() end, "Eval expression")


local M = {}

-- Автодополнение через LSP
-- Можно через telescope тоже самое делать
function M.setup_lsp_keymaps(_, bufnr)
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

return M
