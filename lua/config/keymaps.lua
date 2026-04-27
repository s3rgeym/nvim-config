local map = vim.keymap.set

-- General
map('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })
-- map('n', "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit All" })
-- map('n', "<leader>x", "<cmd>x<cr>", { desc = "Save and Quit" })
-- Лучше использовать :%y, :%d
-- map('n', '<leader>a', 'ggVG', { desc = 'Select All' })
map('n', '<leader>w', vim.cmd.write, { desc = 'Save' })
-- gA может конфликтовать
-- map('n', '<leader>p', 'ggVGp', { desc = 'Replace All with Clipboard' })
-- map('v', '<leader>p', '"_dP', { desc = 'Paste without yankin' })
-- Удалить выделение в черную дыру и вставить из регистра
-- map('n', '<leader>y', ':%y+<cr>', { desc = 'Yank All' })
map('n', '<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })

-- Buffers
-- <Tab> по умолчанию <C-i>
map('n', '<Tab>', vim.cmd.bnext, { desc = 'Next Buffer' })
map('n', '<S-Tab>', vim.cmd.bprev, { desc = 'Previous Buffer' })
map('n', '<BS>', '<C-^>', { desc = 'Alternate Buffer' })
-- Эти сочетания нужны очень редко, я бы задумался об их необходимости
map('n', '<leader>bd', '<cmd>bp | bd #<cr>', { desc = 'Delete Buffer' })
map(
  'n',
  '<leader>bD',
  '<cmd>%bd | e # | bd #<cr>',
  { desc = 'Delete Other Buffers' }
)

-- Windows
map('n', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Window Up' })
map('n', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Window Down' })
map('n', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Window Left' })
map('n', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Window Right' })
map('n', '<A-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Height' })
map('n', '<A-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Height' })
map('n', '<A-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Width' })
map(
  'n',
  '<A-Right>',
  '<cmd>vertical resize +2<cr>',
  { desc = 'Increase Width' }
)
map('n', '<leader>h', vim.cmd.split, { desc = 'Horizontal Split' })
map('n', '<leader>v', vim.cmd.vsplit, { desc = 'Vertical Split' })

-- Lines
-- Движение по переносам (i-режим раздражает из-за ошибок при редактировании)
-- map('n', "<Up>", "gk")
-- map('n', "<Down>", "gj")
-- map('i', "<Up>", "<C-o>gk")
-- map('i', "<Down>", "<C-o>gj")
map('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move Line Up' })
map('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move Line Down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })

-- Indent
-- C-u в insert удаляет до начала строки, эффективно убирая отступ
map('i', '<S-Tab>', '<C-u>', { desc = 'Remove Line Indent' })
map('v', '<Tab>', '>gv', { desc = 'Increase Indent' })
map('v', '<S-Tab>', '<gv', { desc = 'Decrease Indent' })

-- Navigation
map('n', 'H', '^', { desc = 'Move to line start' })
map('n', 'L', 'g_', { desc = 'Move to line end' })

-- map('n', '<cr>', '<C-]>', { desc = 'Help' })

-- map('n', '<leader>cd', '<cmd>lcd %:p:h<cr><cmd>pwd<cr>', { desc = 'Change Directory' })
-- map('n', '<leader>cD', '<cmd>cd %:p:h<cr><cmd>pwd<cr>', { desc = 'Change Directory Globaly' })

-- Replace text
-- map(
--   'n',
--   '<leader>r',
--   [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
--   { desc = 'Replace word under cursor' }
-- )
-- map(
--   'v',
--   '<leader>r',
--   [["hy:%s/<C-r>h//gI<Left><Left><Left>]],
--   { desc = 'Replace selection' }
-- )

-- Config
map('n', '<leader>,', '<cmd>edit $MYVIMRC<cr>', { desc = 'Edit Vim Config' })
--map('n', '', '<cmd>restart<cr>', { desc = 'Restart Vim' })

-- Session
map('n', '<leader>ss', '<cmd>mksession!<cr>', { desc = 'Save Session' })
map('n', '<leader>sl', '<cmd>source Session.vim<cr>', { desc = 'Open Session' })

vim.api.nvim_create_user_command('PackUpdate', function()
  print('Updating packages...')
  vim.pack.update()
  print('Packages updated!')
end, { desc = 'Update all packages' })

map('n', '<leader>pu', '<cmd>PackUpdate<cr>', { desc = 'Update all packages' })
