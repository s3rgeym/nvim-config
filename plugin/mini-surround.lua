-- :h mini.surround
-- saivf - чтобы обернуть переменную в вызов функции
vim.pack.add(
  { 'https://github.com/nvim-mini/mini.surround' },
  { confirm = false }
)

require('mini.surround').setup()
