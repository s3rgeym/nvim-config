-- Этот плагин можно выбросить, тк treesitter давно является встроенным, если
-- не нужен команды для установки парсеров и зависимые от него плагины
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- setup не нужен
local ts = require('nvim-treesitter')

-- You can manually install parsers with `:TSInstall <language>` or
-- `:TSInstall all`
-- ts.install('all')

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local ensure_installed = {
  'bash',
  'c',
  'css',
  'cpp',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'rust',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

ts.install(ensure_installed)

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
