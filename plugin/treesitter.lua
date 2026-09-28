-- Данный плагин лишь предоставляет команды TSInstall и TSUpdate.
-- Парсеры можно ставить через vim.pack.add с { load = false }, который лишь выполняет git clone.
-- В арче пакет tree-sitter является зависимостью nvim, поэтому tree-sitter ставить не нужно.
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- You can manually install parsers with `:TSInstall <language>` or
-- `:TSInstall all`
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
require('nvim-treesitter').install({
  -- В арче все эти парсеры ставятся вместе с nvim
  -- 'c',
  -- 'lua',
  -- 'luadoc',
  -- 'markdown',
  -- 'markdown_inline',
  -- 'vim',
  -- 'vimdoc',
})

-- Treesitter features for installed languages must be enabled manually
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start()

      -- Configure code folding
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'

      vim.wo.foldlevel = 99

      -- Enable treesitter-based indentation
      vim.bo.indentexpr = 'v:lua.vim.treesitter.indentexpr()'
    end
  end,
})

-- Обновление языковых парсеров после обновления Treesitter
-- Без этого они могут сломаться
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd('TSUpdate')
    end
  end,
})
