local setup_lsp_keymaps = require("keymaps").setup_lsp_keymaps

-- Настройки плагинов для lazy.nvim задаются в виде хеш-таблицы (аналог ассоциативных массивов, поддерживающих нумерацию элементов)
return {
  -- Строка статуса
  {
    "nvim-lualine/lualine.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    -- Функция config нужна
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

  -- Автоматическая вставка парных скобок и кавычек
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  -- tree-sitter используется для парсинга исходников в AST для навигации по коду, лучшей подсветки синтаксиса, например, в Vue-компонентах (HTML + JS + CSS), а так же применяется тем же DAP. Без него подсветка синтаксиса будет работать благодаря файлам синтаксиса vim, но вот остальное...
  -- :checkhealth nvim-treesitter (так можно проверить любой плагин)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- Парсеры для каждого языка нужно ставить отдельно
        -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
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
  -- Следует отметить, что не все LSP-сервера поддерживают форматирование, например, pyright не умеет, а ruff — да, поэтому могут понадобиться дополнитеьные плагины
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Добавляем сюда языковые сервера, которые будут установлены
        -- :LspInstall позволяет их поставить вручную
        ensure_installed = {},
        automatic_installation = true,
      })

      -- nvim-cmp setup
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          -- Что дополняем в режиме редактирования?
          { name = "nvim_lsp" }, -- LSP
          { name = "nvim_lua" }, -- Nvim Lua
          { name = "buffer" },   -- Текст из открытых буферов
          { name = "path" },     -- Пути до файлов
          -- Показывает сигнатуры функций с выделением текущих параметров
          { name = 'nvim_lsp_signature_help' }
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Esc>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
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

      -- Тут прописываем языковые сервера, которые надо настроить для использования
      -- :help lspconfig-all
      -- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
      local lsp_servers = {
        "gopls",
        "lua_ls",
        "ruff",
      }

      for _, lsp in ipairs(lsp_servers) do
        lspconfig[lsp].setup({
          on_attach = setup_lsp_keymaps,
          capabilities = capabilities,
        })
      end
    end,
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- nvim-dap-ui requires nvim-nio to be installed. Install from https://github.com/nvim-neotest/nvim-nio
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")

      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      require("mason-nvim-dap").setup({
        ensure_installed = { "python" }, -- автоматически поставит debugpy
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Если debugpy установлен, то можно прописать до него путь вместо установкм через mason-nvim-dap
      -- dap.adapters.python = {
      --   type = 'executable',
      --   command = '/path/to/your/python',
      --   args = { '-m', 'debugpy.adapter' },
      -- }

      -- UI авто-открытие/закрытие
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Клавиши заданы в keymaps
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

  -- Плагины для комментариев и editorconfig не нужны, так как этот функционал встроенный

  -- Посмотр сочетаний клавиш
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      triggers = {
        -- по умолчанию в mode содержится "x", из-за чего при выделении текста с Shift показываются сочетания с v
        { "<auto>", mode = "nso" },
      },
    },
    -- keys = {
    --   {
    --     "<leader>?",
    --     function()
    --       require("which-key").show({ global = false })
    --     end,
    --     desc = "Buffer Local Keymaps (which-key)",
    --   },
    -- },
  },

  -- Тема
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false, -- Загружаем сразу
    opts = {
      -- Включать прозрачность для темы не нужно, если установить colors.transparent_background_colors = true в настройках alacritty
      -- transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
    },
  },
}
