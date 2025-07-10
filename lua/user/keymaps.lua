-- Все сочетания лучше держать в одном месте
local utils = require("user.utils")

local function cmd(command)
  return "<Cmd>" .. command .. "<CR>"
end

local which_key_ok, wk = pcall(require, "which-key")
if not which_key_ok then
  return
end

-- which-key — это то ради чего стоит с vim перейти на neovim
wk.add({
  {
    "<leader>?",
    function()
      wk.show({ global = false })
    end,
    desc = "Buffer Local Keymaps (which-key)",
  },
  -- Подсмотреть глобальные сочетание
  {
    '<C-\\>',
    wk.show,
    mode = { "n", "i", "v" }, -- можно добавить c, o
    desc = "Show all keymaps"
  },
  -- Это один из самых полезных режимов, который позволяет удобно выполнять
  -- разные действия над окнами без лишний нажатий клавиш
  {
    "<c-w><leader>",
    function()
      -- Кроме сочетания <c-w>w в принципе ничего не нужно
      wk.show({ keys = "<c-w>", loop = true })
    end,
    desc = "Window Hydra Mode (which-key)",
  },
})

-- Basic mappings
wk.add({
  {
    mode = { "n", "v" },
    { "<leader>q", vim.cmd.quit,  desc = "Close window" },
    { "<leader>w", vim.cmd.write, desc = "Write file" },
  },

  { "<leader>x",  vim.cmd.bdelete,               desc = "Close buffer" },

  { "<C-a>",      "ggVG",                        desc = "Select entire buffer" },
  { "<Esc><Esc>", vim.cmd.nohlsearch,            desc = "Clear search highlight" },

  -- Нужно придумать сочетание для этого
  --{ "gV",         desc = "Reselect last change/paste" },

  -- Перемещение по перенесенным строкам как по физическим
  { "k",          "gk",                          silent = true },
  { "j",          "gj",                          silent = true },
  { "<Up>",       "gk",                          silent = true },
  { "<Down>",     "gj",                          silent = true },

  -- Window Navigation
  { "<C-h>",      cmd [[wincmd h]],              desc = "Go to left window" },
  { "<C-j>",      cmd [[wincmd j]],              desc = "Go to window below" },
  { "<C-k>",      cmd [[wincmd k]],              desc = "Go to window above" },
  { "<C-l>",      cmd [[wincmd l]],              desc = "Go to right window" },

  -- Resize Windows
  { "<A-Left>",   cmd [[vertical resize -2]],    desc = "Decrease width" },
  { "<A-Right>",  cmd [[vertical resize +2]],    desc = "Increase width" },
  { "<A-Down>",   cmd [[resize -2]],             desc = "Decrease height" },
  { "<A-Up>",     cmd [[resize +2]],             desc = "Increase height" },

  -- Buffer Navigation
  { "<Tab>",      vim.cmd.bnext,                 desc = "Previous buffer" },
  { "<S-Tab>",    vim.cmd.bprev,                 desc = "Next buffer" },

  -- Indentation
  -- Конфликтуют с >}
  -- { ">",         ">>",                          desc = "Indent" },
  -- { "<",          "<<",                          desc = "Unindent" },
  { "<S-Tab>",    "<C-D>",                       desc = "Unindent line",         mode = "i" },
  { "<Tab>",      ">gv",                         desc = "Indent selection",      mode = "v" },
  { "<S-Tab>",    "<gv",                         desc = "Unindent selection",    mode = "v" },

  -- Move Lines
  { "<A-j>",      "<Esc>:m .+1<CR>==",           desc = "Move line down" },
  { "<A-k>",      "<Esc>:m .-2<CR>==",           desc = "Move line up" },
  { "<A-j>",      "<Esc>:m .+1<CR>==gi",         desc = "Move line down",        mode = "i" },
  { "<A-k>",      "<Esc>:m .-2<CR>==gi",         desc = "Move line up",          mode = "i" },
  { "<A-j>",      ":m '>+1<CR>gv=gv",            desc = "Move selection down",   mode = "v" },
  { "<A-k>",      ":m '<-2<CR>gv=gv",            desc = "Move selection up",     mode = "v" },


  { "<leader>-",  vim.cmd.split,                 desc = "Horizontal split" },
  { "<leader>|",  vim.cmd.vsplit,                desc = "Vertical split" },

  { "<leader>v",  group = "Neovim Configuration" },
  { "<leader>ve", cmd [[edit $MYVIMRC]],         desc = "Edit Neo[v]im config" },
  { "<leader>vs", utils.ReloadConfig,            desc = "Reload Neo[v]im config" },

  -- Terminal
  { "<leader>t",  cmd [[split | terminal]],      desc = "Open terminal" },
  { "<Esc>",      [[<C-\><C-n>]],                desc = "Exit terminal mode",    mode = "t" },
  { "<C-h>",      [[<C-\><C-n><C-w>h]],          desc = "Terminal: go left",     mode = "t" },
  { "<C-j>",      [[<C-\><C-n><C-w>j]],          desc = "Terminal: go down",     mode = "t" },
  { "<C-k>",      [[<C-\><C-n><C-w>k]],          desc = "Terminal: go up",       mode = "t" },
  { "<C-l>",      [[<C-\><C-n><C-w>l]],          desc = "Terminal: go right",    mode = "t" },

  -- Spellcheck
  { "<leader>ss", cmd [[setlocal spell!]],       desc = "Toggle Spellcheck" },
})

-- NeoTree
wk.add({
  { "<C-p>", cmd [[Neotree toggle]], desc = "Toggle NeoTree" },
})

-- LSP
local function jump(c)
  -- float=true == open_float
  vim.diagnostic.jump({ count = c, float = false })
end

wk.add({
  -- { "gd",          vim.lsp.buf.definition,       desc = "Go to definition" },
  -- { "gD",          vim.lsp.buf.declaration,      desc = "Go to declaration" },
  -- { "gi",          vim.lsp.buf.implementation,   desc = "Go to implementation" },
  -- { "gr",          vim.lsp.buf.references,       desc = "List references" },
  -- { "gy",          vim.lsp.buf.type_definition,  desc = "Type definition" },
  { "<leader>ca", vim.lsp.buf.code_action,    desc = "Code actions" },
  { "<leader>rn", vim.lsp.buf.rename,         desc = "Rename" },
  { "K",          vim.lsp.buf.hover,          desc = "Hover docs" },
  { "gs",         vim.lsp.buf.signature_help, desc = "Signature help" },
  -- Это сочетание лишнее, но пусть будет
  { "<leader>d",  vim.diagnostic.open_float,  desc = "Diagnostics float" },
  { "[d",         function() jump(-1) end,    desc = "Previous diagnostic" },
  { "]d",         function() jump(1) end,     desc = "Next diagnostic" },
  -- { "<leader>ls",  vim.lsp.buf.document_symbol,  desc = "Document symbols" },
  -- { "<leader>lS",  vim.lsp.buf.workspace_symbol, desc = "Workspace symbols" },
})

-- Debugger
wk.add({
  { "<F5>",  function() require 'dap'.continue() end,          desc = "Debug: Start/Continue" },
  -- Shift-F5 не работает у меня в alacritty/zellij
  { "<F6>",  function() require 'dap'.terminate() end,         desc = "Debug: Terminate" },
  { "<F9>",  function() require 'dap'.toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
  { "<F10>", function() require 'dap'.step_over() end,         desc = "Debug: Step over" },
  { "<F11>", function() require 'dap'.step_into() end,         desc = "Debug: Step into" },
  { "<F12>", function() require 'dap'.step_out() end,          desc = "Debug: Step out" },
  { "<M-e>", function() require 'dapui'.eval() end,            desc = "Debug: Evaluate expression", mode = { "n", "v" } },
})

-- Mason
-- Интерфейс для установки различных LSP/дебаггеров и линтеров с форматтерами
wk.add({ "<leader>M", cmd [[Mason]], desc = "Open Mason UI" })

-- Git Integration
wk.add({
  { "<leader>g",  group = "Git" },
  { "<leader>gs", cmd [[Git]],        desc = "Git status" },
  { "<leader>ga", cmd [[Git add .]],  desc = "Git add" },
  { "<leader>gc", cmd [[Git commit]], desc = "Git commit" },
  { "<leader>gp", cmd [[Git push]],   desc = "Git push" },
  { "<leader>gP", cmd [[Git pull]],   desc = "Git pull" },
  { "<leader>gw", cmd [[Gwrite]],     desc = "Gwrite" },
  { "<leader>gr", cmd [[Gread]],      desc = "Gread" },
  { "<leader>gd", cmd [[Git diff]],   desc = "Git diff" },
  { "<leader>gl", cmd [[Git log]],    desc = "Git log" },
})

-- FzfLua
wk.add({
  { "<leader>/",  cmd [[FzfLua grep_curbuf]],           desc = "Grep current buffer" },
  { "<leader>b",  cmd [[FzfLua buffers]],               desc = "Buffers" },
  { "<leader>f",  cmd [[FzfLua live_grep]],             desc = "Live grep" },
  { "<leader>F",  cmd [[FzfLua files]],                 desc = "Find file" },
  { "<leader>o",  cmd [[FzfLua oldfiles]],              desc = "Recent files" },
  { "<leader>r",  cmd [[FzfLua resume]],                desc = "Resume search" },
  -- LSP
  { "gd",         cmd [[FzfLua lsp_definitions]],       desc = "LSP Definitions (Fzf)" },
  { "gD",         cmd [[FzfLua lsp_declarations]],      desc = "LSP Declarations (Fzf)" },
  { "gi",         cmd [[FzfLua lsp_implementations]],   desc = "LSP Implementations (Fzf)" },
  { "gr",         cmd [[FzfLua lsp_references]],        desc = "LSP References (Fzf)" },
  { "gy",         cmd [[FzfLua lsp_type_definitions]],  desc = "LSP Type Definitions (Fzf)" },
  { "<leader>ls", cmd [[FzfLua lsp_document_symbols]],  desc = "LSP Document Symbols (Fzf)" },
  { "<leader>lS", cmd [[FzfLua lsp_workspace_symbols]], desc = "LSP Workspace Symbols (Fzf)" },
})

-- grug-far
wk.add({
  {
    "<leader>sr",
    function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end,
    desc = "Search and Replace",
    mode = { "n", "v" },
  },
})
