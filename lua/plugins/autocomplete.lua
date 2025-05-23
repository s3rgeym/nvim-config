-- TODO: разбить на подмодули

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "neovim/nvim-lspconfig",
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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Не работает
    -- vim.lsp.config("*", {
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    -- })

    local servers = {
      'lua_ls',
      'gopls',
      'ruff', -- Не поддерживает автодополнения, поэтому используется только в сочетании с pyright
      'pyright',
    }

    -- Можно вынести в keymaps
    local on_attach = function(client, bufnr)
      local function nmap(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = "LSP: " .. desc, buffer = bufnr })
      end

      nmap("gd", vim.lsp.buf.definition, "Go to definition")
      nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
      nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
      nmap("gr", vim.lsp.buf.references, "List references")
      nmap("K", vim.lsp.buf.hover, "Hover documentation")
      nmap("gK", vim.lsp.buf.signature_help, "Signature help")
      nmap("<leader>rs", vim.lsp.buf.rename, "Rename symbol")
      nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
      nmap("<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format Document")
      local jump = function(c)
        vim.diagnostic.jump({ count = c })
      end
      nmap("[d", function() jump(-1) end, "Previous diagnostic")
      nmap("]d", function() jump(1) end, "Next diagnostic")
      nmap("<leader>d", vim.diagnostic.open_float, "Show diagnostics")
    end

    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
      }
    end
  end,
}
