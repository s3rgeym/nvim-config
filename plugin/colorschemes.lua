vim.pack.add({
  { src = 'https://github.com/EdenEast/nightfox.nvim' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/rebelot/kanagawa.nvim' },
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  { src = 'https://github.com/sainnhe/everforest' },
  -- Уродливая тема
  -- { src = 'https://github.com/craftzdog/solarized-osaka.nvim' },
  -- Тема из nitghtfox лучше
  -- { src = 'https://github.com/gbprod/nord.nvim' },
  { src = 'https://github.com/navarasu/onedark.nvim' },
  { src = 'https://github.com/sainnhe/gruvbox-material' },
})

-- setup для тем как правило вызывать не нужно, если только не требуется настройка
-- require('catppuccin').setup({
--   -- Работает неправильно
--   transparent_background = true,
-- })
