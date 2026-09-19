vim.pack.add({
  -- Этот плагин можно выбросить, тк treesitter давно является встроенным, если
  -- не нужен функционал nvim-treesitter-textobjects и др. зависимых плаг-ов
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

-- setup не нужен
local ts = require('nvim-treesitter')

-- You can manually install parsers with `:TSInstall <language>` or
-- `:TSInstall all`
-- ts.install('all')

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local ensure_installed = {
  'angular',
  'astro',
  'bash',
  'c',
  'c_sharp',
  'cmake',
  'cpp',
  'css',
  'csv',
  'dart',
  'desktop',
  'diff',
  'dockerfile',
  'editorconfig',
  'fish',
  'git_config',
  'gitignore',
  'go',
  'graphql',
  'groovy',
  'hcl',
  'html',
  'http',
  'ini',
  'java',
  'javadoc',
  'javascript',
  'jinja',
  'jsdoc',
  'json',
  'json5',
  'jsonnet',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'make',
  'nginx',
  'ninja',
  'nix',
  'perl',
  'php',
  'phpdoc',
  'powershell',
  'proto',
  'python',
  'requirements',
  'ruby',
  'rust',
  'scss',
  'sql',
  'ssh_config',
  'svelte',
  'swift',
  'terraform',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'xml',
  'yaml',
  'zsh',
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
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

require('treesitter-context').setup({
  -- How many lines the window should span. Values <= 0 mean no limit.
  max_lines = 3,
  -- Line used to calculate context. Choices: 'cursor', 'topline'
  mode = 'cursor',
})

require('nvim-treesitter-textobjects').setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        -- ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
  },
})

-- Как запомнить: around/inner method/class/section
-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ 'x', 'o' }, 'am', function()
  require 'nvim-treesitter-textobjects.select'.select_textobject(
    '@function.outer',
    'textobjects'
  )
end)
vim.keymap.set({ 'x', 'o' }, 'im', function()
  require 'nvim-treesitter-textobjects.select'.select_textobject(
    '@function.inner',
    'textobjects'
  )
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require 'nvim-treesitter-textobjects.select'.select_textobject(
    '@class.outer',
    'textobjects'
  )
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require 'nvim-treesitter-textobjects.select'.select_textobject(
    '@class.inner',
    'textobjects'
  )
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ 'x', 'o' }, 'as', function()
  require 'nvim-treesitter-textobjects.select'.select_textobject(
    '@local.scope',
    'locals'
  )
end)
vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
end)
vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer'
end)
