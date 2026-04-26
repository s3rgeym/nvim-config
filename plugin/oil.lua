-- Позволяет работать с файлами в обычном буфере как с текстом
-- Можно так же попобовать альтернативу в виде mini-files
vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/benomahony/oil-git.nvim',
  'https://github.com/JezerM/oil-lsp-diagnostics.nvim',
}, { confirm = false })

require('oil').setup({
  default_file_explorer = true,
  columns = {
    'icon',
  },
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
  watch_for_changes = true,
  view_options = {
    show_hidden = true,
  },
})
require('oil-git').setup()
require('oil-lsp-diagnostics').setup()

local map = require('utils').map
map('-', '<cmd>Oil<cr>', 'Open parent in Oil')
