-- LSP и автодополнение
-- Следует отметить, что не все LSP-сервера поддерживают форматирование, например, pyright не умеет, а ruff — да, поэтому могут понадобиться дополнитеьные плагины
return {
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

    -- autcomd "LspAttach"
    local function on_attach(_, bufnr)
      local function nmap(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = "LSP: " .. desc, buffer = bufnr })
      end

      nmap("gd", vim.lsp.buf.definition, "Go to definition")
      nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
      -- Используются в Telescope
      -- nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
      -- nmap("gr", vim.lsp.buf.references, "List references")
      nmap("K", vim.lsp.buf.hover, "Hover documentation")
      -- На эту клавишу в режиме редактирования по умолчанию уже задано это действие
      nmap("<C-s>", vim.lsp.buf.signature_help, "Signature help")
      nmap("<leader>rs", vim.lsp.buf.rename, "Rename symbol")
      nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
      nmap("<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format Document")
      local function jump(c)
        vim.diagnostic.jump({ count = c, float = true })
      end
      -- vim.diagnostic.goto_prev/vim.diagnostic.goto_next устарели
      nmap("[d", function() jump(-1) end, "Previous diagnostic")
      nmap("]d", function() jump(1) end, "Next diagnostic")
      nmap("<leader>e", vim.diagnostic.open_float, "Show diagnostics")
    end

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
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end,
}
