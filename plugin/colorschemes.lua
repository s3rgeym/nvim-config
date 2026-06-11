-- Устанавливаем темы, но не загружаем их
vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/edeneast/nightfox.nvim',
  'https://github.com/neanias/everforest-nvim',
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/Mofiqul/dracula.nvim',
  'https://github.com/Mofiqul/vscode.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/projekt0n/github-nvim-theme',
  'https://github.com/rebelot/kanagawa.nvim',
}, { confirm = false, load = false })
