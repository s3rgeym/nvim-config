-- sudo pacman -S lazygit
vim.pack.add(
  { 'https://github.com/kdheepak/lazygit.nvim' },
  { confirm = false }
)

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
