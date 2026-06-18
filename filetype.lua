-- https://nickjanetakis.com/blog/custom-file-type-syntax-highlighting-with-neovim
-- Это можно настроить через ./after/lsp/bashls.lua
vim.filetype.add({
  extension = { zsh = 'bash' },
  filename = { ['.zshrc'] = 'bash', ['.zprofile'] = 'bash' },
})
