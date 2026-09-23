-- Хелпер для работы с Git, нетребующий стронних утилит
-- Стандартный коммит: <C-s>, c, a, ввод сообщения, <Esc>, :w, <C-c>, P, p
-- Команду проще ввести, `:!git commit -am '...'; git push`, но тут как-то нагляднее
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
