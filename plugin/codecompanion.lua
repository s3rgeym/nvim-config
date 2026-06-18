vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/olimorris/codecompanion.nvim' },
}, { confirm = false })

local secrets = require('secrets')

require('codecompanion').setup({
  adapters = {
    http = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          env = {
            url = secrets.ollama.base_url,
          },
          schema = {
            model = {
              default = secrets.ollama.model,
            },
          },
        })
      end,
    },
  },

  strategies = {
    chat = {
      adapter = 'ollama',
    },
    inline = {
      adapter = 'ollama',
    },
  },

  -- NOTE: The log_level is in `opts.opts`
  -- opts = {
  --   log_level = 'DEBUG', -- or "TRACE"
  -- },
})

local map = vim.keymap.set

-- Открыть/закрыть чат
map('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')

-- Новый чат
map('n', '<leader>cn', '<cmd>CodeCompanionChat<cr>')

-- Actions (объяснить, исправить, рефактор и т.п.)
map({ 'n', 'v' }, '<leader>ca', '<cmd>CodeCompanionActions<cr>')

-- Добавить выделение в чат
map('v', '<leader>cs', '<cmd>CodeCompanionChat Add<cr>')

-- Inline prompt
map('v', '<leader>ci', '<cmd>CodeCompanion<cr>')
