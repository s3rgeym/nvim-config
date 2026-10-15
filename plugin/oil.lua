-- В Neovim 0.13 появится встроенный файловый менеджер dir.nvim, который так же выводит список файлов,
-- действия же над ними можно через команды выполнять и добавить автокоманду на создание файла при сохранении...
-- Позволяет работать с файлами в обычном буфере как с текстом
-- Можно также попробовать альтернативу в виде mini-files
vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/benomahony/oil-git.nvim',
  'https://github.com/JezerM/oil-lsp-diagnostics.nvim',
})

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
  -- Дергать какой-то калбек для регистрации изменения имени файла, чтобы LSP
  -- переписало импорты
  -- Работает только с включенным
  -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 5000,
  },
})

require('oil-git').setup()
require('oil-lsp-diagnostics').setup()

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent in Oil' })
