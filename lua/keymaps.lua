-- Alt + стрелки, f, g, h, j, k, l используются в Zellij, поэтому их избегаем
-- Также по возможности следует избегать односимвольных сочетаний с `<leader>`, поскольку
-- они могут понадобиться в качестве префиксов для других сочетаний.
-- https://medium.com/unixification/must-have-neovim-keymaps-51c283394070
-- https://www.reddit.com/r/neovim/comments/1h7f0bz/share_your_coolest_keymap/
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Часто его делают ',' или '\\'

-- В Neovim по умолчанию noremap = true, т.е. только встроенные сочетания будут работать в rhs
-- Это позволяет избежать рекурсии
-- silent = true подавляет вывод команд в строку сообщений.
-- Он нужен для vim-команд (строки, нач-ся с `:`, `<Cmd>`)
-- Не нужен для vim.cmd.* и там где есть интерактив и важен вывод.
local map = vim.keymap.set

-- Общие сочетания
-- <C-w>q
-- map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })

-- Сочетание для выбора всего текста не нужно
-- <C-a> я использую для увеличения версии пакета, а <leader>a любят в
-- плагинах
-- map('n', 'g<C-a>', 'ggVG', { desc = 'Select all' })
-- Как альтернативу Ctrl можно использовать Alt
-- map('n', '<A-a>', 'ggVG', { desc = 'Select all' })
-- map('n', '<leader>a', 'ggVG', { desc = 'Select all' })
-- gA свободно в неовим, в обычном вим оно делает почти то же самое, что и ga
-- ga же показывает коды символов под курсором и фактически бесполезен
-- map('n', 'ga', 'ggVG', { desc = 'Select all' })
-- В helix % используется для выбора всего текста, в вим это сочетание занято
-- map('n', '<leader>%', 'ggVG', { desc = 'Select all' })

-- <C-w>c
-- map('n', '<leader>bc', vim.cmd.close, { desc = 'Close buffer' })
-- В Neovim никаких сочетаний нет для Escape в нормальном режиме
map('n', '<Esc>', '<cmd>noh<cr>', { desc = 'Clear highlights' })

-- Буферы
-- H/L переходят по буферам вместо верха/низа экрана
-- map('n', 'H', vim.cmd.bprev, { desc = 'Previous buffer' })
-- map('n', 'L', vim.cmd.bnext, { desc = 'Next buffer' })
map('n', '<Tab>', vim.cmd.bprev, { desc = 'Previous buffer' })
map('n', '<S-Tab>', vim.cmd.bnext, { desc = 'Next buffer' })

-- Нужно придерживаться правила, согласно которому первая буква после <leader> — namespace,
-- а вторая — действие. Например: <leader>b — Buffers, <leader>bd — Delete buffer.
map(
  'n',
  '<leader>bd',
  '<cmd>bp <bar> bd #<cr>',
  { desc = 'Delete current buffer' }
)
map(
  'n',
  '<leader>bD',
  '<cmd>%bd <bar> e # <bar> bd #<cr>',
  { desc = 'Delete other buffers' }
)

-- Окна
map('n', '<C-h>', '<C-w>h', { desc = 'Left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Right window' })

-- Терминал
map('t', '<C-h>', '<cmd>wincmd h<CR>', { desc = 'Left window' })
map('t', '<C-j>', '<cmd>wincmd j<CR>', { desc = 'Lower window' })
map('t', '<C-k>', '<cmd>wincmd k<CR>', { desc = 'Upper window' })
map('t', '<C-l>', '<cmd>wincmd l<CR>', { desc = 'Right window' })

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

-- Для них уже есть <C-w>s и <C-w>v
-- Я по привычке раньше эти сочетания пихал
-- map('n', '<leader>h', vim.cmd.split, { desc = 'Horizontal split' })
-- map('n', '<leader>v', vim.cmd.vsplit, { desc = 'Vertical split' })

-- Вкладки
for i = 1, 9 do
  map('n', '<a-' .. i .. '>', i .. 'gt', { desc = 'Go to tab ' .. i })
end

map('n', '<A-0>', vim.cmd.tablast, { desc = 'Go to last tab' })
map('n', '<leader>tn', vim.cmd.tabnew, { desc = 'New tab' })
map('n', '<leader>tc', vim.cmd.tabclose, { desc = 'Close tab' })
map('n', '<leader>to', vim.cmd.tabonly, { desc = 'Close other tabs' })
map('n', '<leader>tm', '<cmd>tabmove<Space>', { desc = 'Move tab' })

-- Навигация
-- Нужно всегда x использовать вместо v
-- x - Visual, т.е. визуальный режим, только выделение
-- v - Visual + Select. В Select выделение заменяется на вводимые символы
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Перемещение строк
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
map('v', '>', '>gv', { desc = 'Indent' })
map('v', '<', '<gv', { desc = 'Outdent' })
-- От табов нужно отвыкать, но для кого-то привычнее
map('v', '<Tab>', '>gv', { desc = 'Indent' })
map('v', '<S-Tab>', '<gv', { desc = 'Outdent' })

-- Переход к help по Enter
-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- Поиск и замена
-- Замена во всех файлах: :args **/*.py | :argdo %s/\<old\>/new/g | update
-- <leader>r лучше освободить под префикс для других сочетаний
-- map(
--   'n',
--   '<leader>r',
--   ':%s/\\<<C-r><C-w>\\>//g<Left><Left>',
--   { desc = 'Replace word under cursor' }
-- )

-- R в Visual свободно, но можно по аналогии с предыдущим данное действие на
-- то же сочетание повесить
map('v', 'R', [["hy:%s/<C-r>h//g<Left><Left>]], { desc = 'Replace selection' })

-- Конфиги Neovim
map(
  'n',
  '<leader>ev',
  '<cmd>edit $MYVIMRC<cr>',
  { desc = 'Edit Neovim config' }
)

map('n', '<leader>R', function()
  local session = vim.fn.stdpath('state') .. '/restart_session.vim'
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  vim.cmd('restart source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restart Neovim' })

-- Управление плагинами
map('n', '<leader>pu', vim.pack.update, { desc = 'update plugins' })

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
end, { desc = 'clean inactive plugins' })
