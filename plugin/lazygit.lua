-- sudo pacman -S lazygit
vim.pack.add({ 'https://github.com/kdheepak/lazygit.nvim' })

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
