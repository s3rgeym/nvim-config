vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- 'https://github.com/nvim-mini/mini.nvim',            -- if you use the mini.nvim suite
  -- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
  'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}, { confirm = false })
require('render-markdown').setup({}) -- only mandatory if you want to set custom options
