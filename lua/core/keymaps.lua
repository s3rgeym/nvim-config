-- Alt + стрелки, f, g, h, j, k, l используются в Zellij, поэтому они не
-- используются в данном конфиге

-- Клавиша лидер
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- В Neovim в отличии от Vim по умолчанию noremap = true, поэтому
-- пользовательские сочетания в rhs не будут разворачиваться,
-- будут работать только встроенные
local map = vim.keymap.set

map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })
-- Я это сочетание редко использую
-- map('n', '<leader>a', 'ggVG', { desc = 'Select [a]ll' })
-- <C-w>c
-- map('n', '<leader>bc', vim.cmd.close, { desc = 'Close buffer' })
-- Esc ничего не делает в нормальном режиме в Neovim. Я не помню почему в Vim
-- на него нельзя было повесить очистку экрана
map('n', '<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear search highlight' })

-- Buffers
-- H и L по умолчанию служат для перехода в начало и конец буфера
map('n', 'H', vim.cmd.bprev, { desc = 'Previous Buffer' })
map('n', 'L', vim.cmd.bnext, { desc = 'Next Buffer' })
-- Эти сочетания нужны очень редко, я бы задумался об их необходимости
-- <leader>d и <leader>x под плагины оставил
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
-- Выбор таба с помощью Alt+1..9
for i = 1, 9 do
  map('n', '<a-' .. i .. '>', i .. 'gt', { desc = 'Go to Tab ' .. i })
end

map('n', '<A-0>', vim.cmd.tablast, { desc = 'Go to last tab' })
map('n', '<leader>tn', vim.cmd.tabnew, { desc = 'New tab' })
map('n', '<leader>tc', vim.cmd.tabclose, { desc = 'Close tab' })

-- движение по переносам строк
-- Вместо v лучше всегда использовать x, если не предполагается работа в режиме Select.
-- v включает режим визуального выделения (Visual) и режим замены выделения (Select).
-- x работает только в визуальном режиме (Visual), что предотвращает случайный перехват
-- клавиш в режиме Select.
map(
  { 'n', 'x' },
  'j',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { 'n', 'x' },
  '<Down>',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { 'n', 'x' },
  'k',
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
map(
  { 'n', 'x' },
  '<Up>',
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Перемещение строк
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })

-- Отступы
-- Не будет работать, например, если в буфере в режиме вставки повесить на него действие
-- map('i', '<S-Tab>', '<C-d>', { desc = 'Outdent line' })
map('v', '<Tab>', '>gv', { desc = 'Indent' })
map('v', '<S-Tab>', '<gv', { desc = 'Outdent' })
map('n', '<Tab>', '>>', { desc = 'Indent line' })
map('n', '<S-Tab>', '<<', { desc = 'Outdent line' })

-- Просто Enter для отображения справки
-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- Замена строк от s — substitute

-- Для замены во всех файлах с расширением питон:
-- :args **/*.py
-- :argdo %s/\<старое_слово\>/новое_слово/g | update
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

-- Neovim
map(
  'n',
  '<leader>ev',
  '<cmd>edit $MYVIMRC<cr>',
  { desc = 'Edit Neo[v]im Config' }
)
-- <leader>r оставил для других сочетаний
map('n', '<leader>rv', vim.cmd.restart, { desc = 'Restart Neo[v]im' })

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
end, { desc = 'Clean plugins' })
