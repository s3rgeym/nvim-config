vim.pack.add(
  { 'https://github.com/MagicDuck/grug-far.nvim' },
  { confirm = false }
)
vim.keymap.set('n', '<leader>sr', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and '*.' .. ext or nil,
    },
  })
end, { desc = 'Search and Replace' })
