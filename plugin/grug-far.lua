vim.pack.add(
  { 'https://github.com/MagicDuck/grug-far.nvim' },
  { confirm = false }
)
local map = require('utils').map
local grug = require('grug-far')
grug.setup()
map('<leader>sr', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and '*.' .. ext or nil,
    },
  })
end, 'Search and Replace')
