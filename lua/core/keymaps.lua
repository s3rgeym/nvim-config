-- Alt + стрелки, f, g, h, j, k, l используются в Zellij, поэтому их избегаем
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- В Neovim по умолчанию noremap = true, т.е. только встроенные сочетания будут работать в rhs
-- Это позволяет избежать рекурсии
-- silent = true подавляет вывод команд в строку сообщений.
-- Он нужен для vim-команд (строки, нач-ся с `:`, `<Cmd>`)
-- Не нужен для vim.cmd.* и там где есть интерактив и важен вывод.
local map = vim.keymap.set

-- Общие сочетания
map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })
-- Для выделения и копирования - :%y
-- map('n', '<leader>a', 'ggVG', { desc = 'Select all' })
-- <C-w>c
-- map('n', '<leader>bc', vim.cmd.close, { desc = 'Close buffer' })
-- В Neovim никаких сочетаний нет для Escape в нормальном режиме
map('n', '<Esc>', '<cmd>noh<cr>', { desc = 'Clear search highlight' })

-- Буферы
-- H/L переходят по буферам вместо верха/низа экрана
map('n', 'H', vim.cmd.bprev, { desc = 'Previous buffer' })
map('n', 'L', vim.cmd.bnext, { desc = 'Next buffer' })
-- Эти сочетания редко используются
map(
  'n',
  '<leader>bd',
  '<cmd>bp <bar> bd #<cr>',
  { desc = 'Delete current buffer' }
)
map(
  'n',
  '<leader>bo',
  '<cmd>%bd <bar> e # <bar> bd #<cr>',
  { desc = 'Delete other buffers' }
)

-- Окна
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

map('n', '<C-Up>', '<cmd>resize +2<cr>', {
  desc = 'Increase window height',
})
map('n', '<C-Down>', '<cmd>resize -2<cr>', {
  desc = 'Decrease window height',
})
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', {
  desc = 'Decrease window width',
})
map(
  'n',
  '<C-Right>',
  '<cmd>vertical resize +2<cr>',
  { desc = 'Increase window width' }
)

map('n', '<leader>h', vim.cmd.split, { desc = 'Horizontal split' })
map('n', '<leader>v', vim.cmd.vsplit, { desc = 'Vertical split' })

-- Вкладки
for i = 1, 9 do
  map('n', '<a-' .. i .. '>', i .. 'gt', { desc = 'Go to tab ' .. i })
end

map('n', '<A-0>', vim.cmd.tablast, { desc = 'Go to last tab' })
map('n', '<leader>tn', vim.cmd.tabnew, { desc = 'New tab' })
map('n', '<leader>tc', vim.cmd.tabclose, { desc = 'Close tab' })

-- Навигация
-- Нужно всегда x использовать вместо v
-- x - Visual, т.е. визуальный режим, только выделение
-- v - Visual + Select. В Select выделение заменяется на вводимые символы
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Перемещение выделения
map('x', 'K', ":m '<-2<CR>gv=gv", {
  desc = 'Move selection up',
  silent = true,
})
map('x', 'J', ":m '>+1<CR>gv=gv", {
  desc = 'Move selection down',
  silent = true,
})

-- Отступы
-- Это сочетание не будет работать, так как на Shift-Tab вешают выбор предыдущего элемента из списка
-- map('i', '<S-Tab>', '<C-d>', { desc = 'Outdent line' })
map('v', '<Tab>', '>gv', { desc = 'Indent selection' })
map('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })
map('n', '<Tab>', '>>', { desc = 'Indent line' })
map('n', '<S-Tab>', '<<', { desc = 'Outdent line' })

-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- Поиск и замена
-- Замена во всех файлах: :args **/*.py | :argdo %s/\<old\>/new/g | update
map(
  'n',
  '<leader>s',
  ':%s/\\<<C-r><C-w>\\>//g<Left><Left>',
  { desc = 'Replace word under cursor' }
)
map(
  'v',
  '<leader>s',
  [["hy:%s/<C-r>h//g<Left><Left>]],
  { desc = 'Replace selection' }
)

-- Конфиги Neovim
map(
  'n',
  '<leader>ev',
  '<cmd>edit $MYVIMRC<cr>',
  { desc = 'Edit Neovim config' }
)
map('n', '<leader>rv', vim.cmd.restart, { desc = 'Restart Neovim' })

-- Управление плагинами
map('n', '<leader>pu', vim.pack.update, { desc = 'Update plugins' })

map('n', '<leader>pc', function()
  vim.pack.del(vim
    .iter(vim.pack.get())
    :filter(function(plugin)
      return not plugin.active
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable())
end, { desc = 'Clean inactive plugins' })
