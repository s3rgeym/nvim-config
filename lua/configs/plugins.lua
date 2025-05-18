local setup_lsp_keymaps = require("configs.keymaps").setup_lsp_keymaps

return {
  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        filters = { dotfiles = false },
        git = { enable = true },
        actions = {
          open_file = {
            quit_on_open = true, -- закроет дерево после открытия файла
          },
        },
        -- авто-закрытие при последнем буфере
        -- только если включена эта настройка:
        hijack_netrw = true,
      })
    end,
  },

  -- Поиск по файлам
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup({
        -- Тут какие-то настройки
      })
      -- require('telescope').load_extension('fzf')
    end
  },

  -- tree-sitter используется для парсинга сходников
  -- :checkhealth nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- Парсеры для каждого языка нужно ставить отдельно
        ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "go", "rust", "java", "javascript", "php", "vue", "html", "json", "toml", "yaml" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP и Автодополнение
  -- https://medium.com/@rishavinmngo/how-to-setup-lsp-in-neovim-1c3e5073bbd1
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp.mapping.scroll_docs(-4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        })
      })

      local lspconfig = require('lspconfig')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- npm install -g pyright
      -- sudo pacman -S gopls lua-language-server
      -- Mason может автоматически ставить зависимости
      -- Тут нужно вписать названия серверов, поддерживаемых nvim-lspconfig
      local servers = {
        'pyright',
        'gopls',
        'lua_ls',
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = setup_lsp_keymaps,
          capabilities = capabilities,
        }
      end
    end
  },

  -- Выделение отступов
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
    end
  },

  -- Нижняя строка статуса
  {
    "nvim-lualine/lualine.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('lualine').setup({
        sections = {
          lualine_x = {
            -- Добавим отображение раскладки
            {
              function()
                if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
                  return '⌨ ' .. vim.b.keymap_name
                end
                return ''
              end,
              cond = function() -- Показывать только если раскладка активна
                return vim.opt.iminsert:get() > 0 and vim.b.keymap_name ~= nil
              end,
            },
            'encoding',
            'fileformat',
            'filetype',
          }
        }
      })
    end
  },

  -- Верхняя строка статуса (заменяет табы)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {
        options = {
          mode = "buffers",
          separator_style = "slant"
        }
      }
    end,
  },

  -- Тема
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false, -- Загружаем сразу
    opts = {
      -- transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
    },
  },

  -- Фиксим прозрачность
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = {
      extra_groups = {},
      exclude_groups = {},
    },
  },
}
