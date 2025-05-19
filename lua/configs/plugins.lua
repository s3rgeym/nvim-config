local setup_lsp_keymaps = require("configs.keymaps").setup_lsp_keymaps

return {
  -- Строка статуса
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

  -- Отображение вкладок
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
        ensure_installed = {
          "c",
          "go",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "php",
          "python",
          "rust",
          "toml",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP и автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Добавляем сюда языковые сервера, которые будут автоматически установлены
        ensure_installed = {
          -- "pyright",
          -- не включаем gopls/lua_ls, они обычно идут с компилятором
        },
        automatic_installation = true,
      })

      -- nvim-cmp setup
      local cmp = require("cmp")
      cmp.setup({
        -- Что дополняем в режиме редактирования?
        sources = {
          { name = "nvim_lsp" }, -- LSP
          { name = "nvim_lua" }, -- Nvim Lua
          { name = "buffer" },   -- Текст из открытых буферов
          { name = "path" },     -- Пути до файдов
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Esc>'] = cmp.mapping.close(),
        }),
      })

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })

      -- LSP servers setup
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "pyright",
        "gopls",
        "lua_ls",
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = setup_lsp_keymaps,
          capabilities = capabilities,
        })
      end
    end,
  },

  -- Отделение отступов вертикальными символами
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
    end
  },

  -- Отображение изменений в Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Посмотр сочетаний клавиш
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
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

  -- Фиксим прозрачность (не все темы ее поддерживают)
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = {
      extra_groups = {},
      exclude_groups = {},
    },
  },
}
