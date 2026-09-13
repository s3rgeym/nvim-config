-- Alt + стрелки, f, g, h, j, k, l исп-ся в Zellij, поэтому их использование
-- нежелательно!

-- Вместо v лучше всегда использовать x, если не предполагается работа в режиме Select.
-- v включает режим визуального выделения (Visual) и режим замены выделения (Select).
-- x работает только в визуальном режиме (Visual), что предотвращает случайный перехват
-- клавиш в режиме Select.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })
map('n', '<leader>y', '<cmd>%y"+<cr>', { desc = 'Yank all' })
map('n', '<leader>p', 'ggVG"_d"+P', { desc = 'Paste over entire file' })
-- Можно на d просто повесить
map({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })
-- <C-w>c
-- map('n', '<leader>bc', vim.cmd.close, { desc = 'Close buffer' })
-- Esc ничего не делает в нормальном режиме в Neovim. Я не помню почему в Vim
-- на него нельзя было повесить очистку экрана
map('n', '<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear search highlight' })

-- Buffers
-- <Tab> в терминалах возвращает тот же самый код, что и CTRL-I, поэтому его
-- переопределение может сломать навигацию по истории, так что для
-- универсальности их лучше не использовать
-- map('n', '<C-i>', '<C-i>')
-- map('n', '<Tab>', vim.cmd.bnext, { desc = 'Next Buffer' })
-- map('n', '<S-Tab>', vim.cmd.bprev, { desc = 'Previous Buffer' })
-- map('n', '<BS>', '<C-^>', { desc = 'Alternate Buffer' })
-- map('n', '<leader>bn', vim.cmd.bnext, { desc = 'Next Buffer' })
-- map('n', '<leader>bp', vim.cmd.bprev, { desc = 'Previous Buffer' })
-- H и L служат для перехода в начало и конец буфера
map('n', 'H', vim.cmd.bprev, { desc = 'Previous Buffer' })
map('n', 'L', vim.cmd.bnext, { desc = 'Next Buffer' })
-- Эти сочетания нужны очень редко, я бы задумался об их необходимости
map(
  'n',
  '<leader>x',
  '<cmd>bp <bar> bd #<cr>',
  { desc = 'Delete current buffer' }
)
map(
  'n',
  '<leader>X',
  '<cmd>%bd <bar> e # <bar> bd #<cr>',
  { desc = 'Delete other buffers' }
)

-- windows
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window' })

map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease width' })
map(
  'n',
  '<C-Right>',
  '<cmd>vertical resize +2<cr>',
  { desc = 'Increase width' }
)

map('n', '<leader>h', vim.cmd.split, { desc = 'Horizontal split' })
map('n', '<leader>v', vim.cmd.vsplit, { desc = 'Vertical split' })

-- Tabs
map('n', '<leader>tn', vim.cmd.tabnew, { desc = 'New tab' })
map('n', '<leader>tc', vim.cmd.tabclose, { desc = 'Close tab' })
map('n', '<A-0>', vim.cmd.tablast, { desc = 'Go to last tab' })

-- Выбор таба с помощью Alt+1..9
for i = 1, 9 do
  map('n', '<a-' .. i .. '>', i .. 'gt', { desc = 'Go to Tab ' .. i })
end

-- движение по переносам строк
map({ 'n', 'x' }, 'j', 'gj')
map({ 'n', 'x' }, 'k', 'gk')
map({ 'n', 'x' }, '<Down>', 'gj')
map({ 'n', 'x' }, '<Up>', 'gk')
-- в режиме редактирования раздражает отображение ошибок из-за скрытого
-- переключения режимов
-- map('i', "<up>", "<c-o>gk")
-- map('i', "<down>", "<c-o>gj")

-- Перемещение строк
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })

-- Indent
-- C-u в insert удаляет до начала строки, эффективно убирая отступ
map('i', '<S-Tab>', '<C-d>', { desc = 'Remove line indent' })
map('x', '<Tab>', '>gv', { desc = 'Increase indent' })
map('x', '<S-Tab>', '<gv', { desc = 'Decrease indent' })

-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- Config
map(
  'n',
  '<leader>ev',
  '<cmd>edit $MYVIMRC<cr>',
  { desc = 'Edit Neo[v]im Config' }
)
-- <leader>r оставил для других сочетаний
map('n', '<leader>rv', vim.cmd.restart, { desc = 'Restart Neo[v]im' })

-- Session
map('n', '<leader>ss', '<cmd>mksession!<cr>', { desc = 'Save session' })
map('n', '<leader>sl', '<cmd>source Session.vim<cr>', { desc = 'Load session' })

-- Сомнительно
map('n', '<leader>tw', '<cmd>setlocal wrap!<cr>', { desc = 'Toggle Wrap' })

-- Управление плагинами
map('n', '<leader>U', function()
  -- vim.pack.update({ force = true })
  vim.pack.update {}
end, { desc = 'Update plugins' })
