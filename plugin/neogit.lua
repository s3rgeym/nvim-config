-- Хелпер для работы с Git, нетребующий стронних утилит

vim.pack.add({
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})

vim.keymap.set(
  'n',
  '<leader>gg',
  '<cmd>Neogit<cr>',
  { desc = 'Open Neogit UI' }
)
