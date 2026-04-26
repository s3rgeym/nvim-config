-- Сочетания объявляются через keys в lazy, не через which-key
local map = require('utils').map

-- General
map('<leader>q', vim.cmd.quit, 'Quit')
-- map("<leader>Q", "<cmd>qa!<cr>", "Quit All")
-- map("<leader>x", "<cmd>x<cr>", "Save and Quit")
-- Лучше использовать :%y, :%d
-- map('<leader>a', 'ggVG', 'Select All')
map('<leader>w', vim.cmd.write, 'Save')
-- gA может конфликтовать
-- map('<leader>p', 'ggVGp', 'Replace All with Clipboard')
-- map('<leader>p', '"_dP', 'Paste without yankin', 'v')
-- Удалить выделение в черную дыру и вставить из регистра
-- map('<leader>y', ':%y+<cr>', 'Yank All')
map('<Esc>', '<cmd>noh<cr><esc>', 'Clear hlsearch')

-- Buffers
-- <Tab> по умолчанию <C-i>
map('<Tab>', vim.cmd.bnext, 'Next Buffer')
map('<S-Tab>', vim.cmd.bprev, 'Previous Buffer')
map('<BS>', '<C-^>', 'Alternate Buffer')
-- Эти сочетания нужны очень редко, я бы задумался об их необходимости
map('<leader>bd', '<cmd>bp | bd #<cr>', 'Delete Buffer')
map('<leader>bD', '<cmd>%bd | e # | bd #<cr>', 'Delete Other Buffers')

-- Windows
map('<C-k>', '<cmd>wincmd k<cr>', 'Window Up')
map('<C-j>', '<cmd>wincmd j<cr>', 'Window Down')
map('<C-h>', '<cmd>wincmd h<cr>', 'Window Left')
map('<C-l>', '<cmd>wincmd l<cr>', 'Window Right')
map('<A-Up>', '<cmd>resize +2<cr>', 'Increase Height')
map('<A-Down>', '<cmd>resize -2<cr>', 'Decrease Height')
map('<A-Left>', '<cmd>vertical resize -2<cr>', 'Decrease Width')
map('<A-Right>', '<cmd>vertical resize +2<cr>', 'Increase Width')
map('<leader>h', vim.cmd.split, 'Horizontal Split')
map('<leader>v', vim.cmd.vsplit, 'Vertical Split')

-- Lines
-- Движение по переносам (i-режим раздражает из-за ошибок при редактировании)
-- map("<Up>", "gk")
-- map("<Down>", "gj")
-- map("<Up>", "<C-o>gk", nil, "i")
-- map("<Down>", "<C-o>gj", nil, "i")
map('<A-k>', '<cmd>m .-2<CR>==', 'Move Line Up')
map('<A-j>', '<cmd>m .+1<CR>==', 'Move Line Down')
map('<A-k>', ":m '<-2<CR>gv=gv", 'Move Selection Up', 'v')
map('<A-j>', ":m '>+1<CR>gv=gv", 'Move Selection Down', 'v')

-- Indent
-- C-u в insert удаляет до начала строки, эффективно убирая отступ
map('<S-Tab>', '<C-u>', 'Remove Line Indent', 'i')
map('<Tab>', '>gv', 'Increase Indent', 'v')
map('<S-Tab>', '<gv', 'Decrease Indent', 'v')

-- Navigation
map('H', '^', 'Move to line start')
map('L', 'g_', 'Move to line end')

map('<cr>', '<C-]>', 'Help')

-- map('<leader>cd', '<cmd>lcd %:p:h<cr><cmd>pwd<cr>', 'Change Directory')
-- map('<leader>cD', '<cmd>cd %:p:h<cr><cmd>pwd<cr>', 'Change Directory Globaly')

-- Replace text
map(
  '<leader>r',
  [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
  'Replace word under cursor'
)
map(
  '<leader>r',
  [["hy:%s/<C-r>h//gI<Left><Left><Left>]],
  'Replace selection',
  'v'
)

-- Config
map('<leader>,', '<cmd>edit $MYVIMRC<cr>', 'Edit Vim Config')
--map('', '<cmd>restart<cr>', 'Restart Vim')

-- Session
map('<leader>ss', '<cmd>mksession!<cr>', 'Save Session')
map('<leader>so', '<cmd>source Session.vim<cr>', 'Open Session')

vim.api.nvim_create_user_command('PackUpdate', function()
  print('Updating packages...')
  vim.pack.update()
  print('Packages updated!')
end, { desc = 'Update all packages' })

map('<leader>pu', '<cmd>PackUpdate<cr>', 'Update all packages')
