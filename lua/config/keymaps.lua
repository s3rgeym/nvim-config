local map = vim.keymap.set

-- General
map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
-- map('n', "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit All" })
-- map('n', "<leader>x", "<cmd>x<cr>", { desc = "Save and Quit" })
-- Как вариант можно использовать <A-a>
-- vim.keymap.set('n', '<C-a>', 'ggVG"+y', { desc = 'Select All' })
-- <leader>a для aerial.nvim
map('n', '<leader>y', '<cmd>%y+<cr>', { desc = 'Copy all' })
map(
  'n',
  '<leader>p',
  '<cmd>%delete _ | put +<CR>', -- ggVG"_dP
  { desc = 'Replace Buffer with the clipboard' }
)
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })
map('n', '<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })

-- Buffers
-- <Tab> в терминалах возвращает тот же самый код, что и CTRL-I, поэтому его
-- переопределение может сломать навигацию по истории
-- map('n', '<C-i>', '<C-i>')
-- map('n', '<Tab>', vim.cmd.bnext, { desc = 'Next Buffer' })
-- map('n', '<S-Tab>', vim.cmd.bprev, { desc = 'Previous Buffer' })
-- map('n', '<BS>', '<C-^>', { desc = 'Alternate Buffer' })
map('n', '<leader>bp', vim.cmd.bprev, { desc = 'Previous Buffer' })
map('n', '<leader>bn', vim.cmd.bnext, { desc = 'Next Buffer' })
-- Эти сочетания нужны очень редко, я бы задумался об их необходимости
map('n', '<leader>bd', '<cmd>bp <bar> bd #<cr>', { desc = 'delete buffer' })
map(
  'n',
  '<leader>bd',
  '<cmd>%bd <bar> e # <bar> bd #<cr>',
  { desc = 'delete other buffers' }
)

-- windows
map('n', '<c-k>', '<cmd>wincmd k<cr>', { desc = 'window up' })
map('n', '<c-j>', '<cmd>wincmd j<cr>', { desc = 'window down' })
map('n', '<c-h>', '<cmd>wincmd h<cr>', { desc = 'window left' })
map('n', '<c-l>', '<cmd>wincmd l<cr>', { desc = 'window right' })
map('n', '<a-up>', '<cmd>resize +2<cr>', { desc = 'increase height' })
map('n', '<a-down>', '<cmd>resize -2<cr>', { desc = 'decrease height' })
map('n', '<a-left>', '<cmd>vertical resize -2<cr>', { desc = 'decrease width' })
map(
  'n',
  '<a-right>',
  '<cmd>vertical resize +2<cr>',
  { desc = 'increase width' }
)
map('n', '<leader>h', vim.cmd.split, { desc = 'horizontal split' })
map('n', '<leader>v', vim.cmd.vsplit, { desc = 'vertical split' })

-- lines
-- движение по переносам
map({ 'n', 'x' }, '<up>', 'gk')
map({ 'n', 'x' }, '<down>', 'gj')
-- в режиме редактирования раздражает отображение ошибок из-за скрытого
-- переключения режимов
-- map('i', "<up>", "<c-o>gk")
-- map('i', "<down>", "<c-o>gj")
map(
  { 'n', 'x' },
  'j',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { 'n', 'x' },
  'k',
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
map('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move Line Up' })
map('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move Line Down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })

-- Indent
-- C-u в insert удаляет до начала строки, эффективно убирая отступ
map('i', '<S-Tab>', '<C-u>', { desc = 'Remove Line Indent' })
map('v', '<Tab>', '>gv', { desc = 'Increase Indent' })
map('v', '<S-Tab>', '<gv', { desc = 'Decrease Indent' })

-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- map(
--   'n',
--   '<leader>cd',
--   '<cmd>lcd %:p:h<cr><cmd>pwd<cr>',
--   { desc = 'Change Directory' }
-- )
-- map(
--   'n',
--   '<leader>cD',
--   '<cmd>cd %:p:h<cr><cmd>pwd<cr>',
--   { desc = 'Change Directory Globally' }
-- )

-- Очень сложно весь этот набор клавиш запомнить, поэтому эти сочетания очень
-- полезны
map(
  'n',
  '<leader>rw',
  [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
  { desc = 'Replace word under cursor' }
)
map(
  'v',
  '<leader>rs',
  [["hy:%s/<C-r>h//gI<Left><Left><Left>]],
  { desc = 'Replace selection' }
)

-- Config
map('n', '<leader>e', '<cmd>tabedit $MYVIMRC<cr>', { desc = 'Edit Vim Config' })
-- Еще можно сохранять сессию перед перезапуском, а после загружать ее,
-- чтобы сохранить расположение окон
map('n', '<leader>R', '<cmd>restart<cr>', { desc = 'Restart Vim' })

-- Session
map('n', '<leader>ss', '<cmd>mksession!<cr>', { desc = 'Save Session' })
map('n', '<leader>ls', '<cmd>source Session.vim<cr>', { desc = 'Load Session' })

vim.api.nvim_create_user_command('PackUpdate', function()
  print('Updating packages...')
  vim.pack.update()
  print('Packages updated!')
end, { desc = 'Update all packages' })

map('n', '<leader>U', '<cmd>PackUpdate<cr>', { desc = 'Update all packages' })

-- Удаляем встроенные сочетания
-- for _, mapping in ipairs({ 'gra', 'gri', 'grn', 'grt' }) do
--   vim.keymap.del('n', mapping)
-- end
