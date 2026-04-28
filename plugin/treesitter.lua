-- Нужна утилита nvim-treesitter-cli... Можно через mason установить.
vim.pack.add({
  -- !!! nvim-treesitter заброшен, а значит должен быть заменен
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}, { confirm = false })

local ts = require('nvim-treesitter')
local ensure_installed = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'css',
  'csv',
  'dockerfile',
  'editorconfig',
  'go',
  'html',
  'java',
  'javadoc',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'php',
  'phpdoc',
  'python',
  'rust',
  'scss',
  'sql',
  'ssh_config',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'yaml',
}

ts.setup({})

-- NOTE: If languages fail to install or compilation hangs,
-- ensure 'tree-sitter-cli' is installed (e.g., :MasonInstall tree-sitter-cli).
-- If the issue persists, run :checkhealth nvim-treesitter to diagnose.

-- Use :TSInstall for manuall install languages
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

-- Обновление языковых парсеров после обновления Treesitter (могут сломаться без этого)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd('TSUpdate')
    end
  end,
})

require('treesitter-context').setup({
  max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
  mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
})

require('nvim-treesitter-textobjects').setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      -- Это сочетания для режима выделения!
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',

        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',

        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',

        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
      },
    },

    move = {
      enable = true,
      set_jumps = true,

      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
      },

      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
      },

      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
      },

      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },

    -- Эти сочетания не нужны мне совсем
    -- swap = {
    --   enable = true,
    --   swap_next = {
    --     ["<leader>a"] = "@parameter.inner",
    --   },
    --   swap_previous = {
    --     ["<leader>A"] = "@parameter.inner",
    --   },
    -- },
  },
})
