return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
  },
  config = function()
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
        -- <Esc> будет мешать выйти из режима вставки, пока открыто меню
        ["<C-e>"] = cmp.mapping.abort(),
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
        -- Выбор вариантов стрелками при редактировани мешает
        -- ['<Down>'] = cmp.mapping(function(fallback)
        --   cmp.close()
        --   fallback()
        -- end, { "i" }),
        -- ['<Up>'] = cmp.mapping(function(fallback)
        --   cmp.close()
        --   fallback()
        -- end, { "i" }),
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
  end
}
