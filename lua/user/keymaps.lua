-- Все сочетания лучше держать в одном месте
local which_key_ok, wk = pcall(require, "which-key")
if not which_key_ok then
  return
end

local function cmd(command)
  return "<Cmd>" .. command .. "<CR>"
end

-- Basic keybindings
wk.add({
  {
    mode = { "n", "v" },
    { "<leader>q", cmd [[q]],     desc = "Quit window" },
    { "<leader>w", cmd [[write]], desc = "Write file" },
  },

  { "<C-a>",      "ggVG",                        desc = "Select entire buffer" },
  { "<Esc>",      cmd [[nohlsearch]],            desc = "Clear search highlight" },

  -- Window Navigation
  { "<C-h>",      "<C-w>h",                      desc = "Go to left window" },
  { "<C-j>",      "<C-w>j",                      desc = "Go to window below" },
  { "<C-k>",      "<C-w>k",                      desc = "Go to window above" },
  { "<C-l>",      "<C-w>l",                      desc = "Go to right window" },
  { "<Tab>",      "<C-w>w",                      desc = "Next window" },
  { "<S-Tab>",    "<C-w>W",                      desc = "Previous window" },

  -- Resize Windows
  { "<A-Left>",   cmd [[vertical resize -2]],    desc = "Decrease width" },
  { "<A-Right>",  cmd [[vertical resize +2]],    desc = "Increase width" },
  { "<A-Down>",   cmd [[resize -2]],             desc = "Decrease height" },
  { "<A-Up>",     cmd [[resize +2]],             desc = "Increase height" },

  -- Buffer Navigation
  { "<C-Left>",   cmd [[bp]],                    desc = "Previous buffer" },
  { "<C-Right>",  cmd [[bn]],                    desc = "Next buffer" },

  -- Indentation
  { "<S-Tab>",    "<C-D>",                       desc = "Unindent line",         mode = "i" },
  { "<Tab>",      ">gv",                         desc = "Indent selection",      mode = "v" },
  { "<S-Tab>",    "<gv",                         desc = "Unindent selection",    mode = "v" },

  -- Move Lines
  { "<C-Up>",     "<Esc>:m .-2<CR>==gi",         desc = "Move line up",          mode = "i" },
  { "<C-Down>",   "<Esc>:m .+1<CR>==gi",         desc = "Move line down",        mode = "i" },
  { "<C-Up>",     ":m '<-2<CR>gv=gv",            desc = "Move selection up",     mode = "v" },
  { "<C-Down>",   ":m '>+1<CR>gv=gv",            desc = "Move selection down",   mode = "v" },

  { "<leader>s",  group = "Split windows" },
  { "<leader>sh", cmd [[split]],                 desc = "Horizontal split" },
  { "<leader>sv", cmd [[vsplit]],                desc = "Vertical split" },

  { "<leader>v",  group = "Neovim Configuration" },
  { "<leader>ve", cmd [[edit $MYVIMRC]],         desc = "Edit config" },
  { "<leader>vs", cmd [[source $MYVIMRC]],       desc = "Reload config" },

  -- Terminal
  { "<leader>t",  cmd [[split | terminal]],      desc = "Open terminal" },
  { "<Esc>",      [[<C-\><C-n>]],                desc = "Exit terminal mode",    mode = "t" },
  { "<C-h>",      [[<C-\><C-n><C-w>h]],          desc = "Terminal: go left",     mode = "t" },
  { "<C-j>",      [[<C-\><C-n><C-w>j]],          desc = "Terminal: go down",     mode = "t" },
  { "<C-k>",      [[<C-\><C-n><C-w>k]],          desc = "Terminal: go up",       mode = "t" },
  { "<C-l>",      [[<C-\><C-n><C-w>l]],          desc = "Terminal: go right",    mode = "t" },

  -- Spellcheck
  { "<leader>sp", cmd [[setlocal spell!]],       desc = "Toggle spellcheck" },
})


-- NeoTree
wk.add({
  { "<leader>n", cmd [[Neotree toggle]], desc = "Toggle NeoTree" },
})

-- LSP
local function jump(c)
  vim.diagnostic.jump({ count = c })
end

wk.add({
  { "gd",         vim.lsp.buf.definition,       desc = "Go to definition" },
  { "gD",         vim.lsp.buf.declaration,      desc = "Go to declaration" },
  { "gi",         vim.lsp.buf.implementation,   desc = "Go to implementation" },
  { "gr",         vim.lsp.buf.references,       desc = "List references" },
  { "gy",         vim.lsp.buf.type_definition,  desc = "Type definition" },
  { "<leader>ca", vim.lsp.buf.code_action,      desc = "Code actions" },
  { "<leader>rn", vim.lsp.buf.rename,           desc = "Rename" },
  { "K",          vim.lsp.buf.hover,            desc = "Hover docs" },
  { "gK",         vim.lsp.buf.signature_help,   desc = "Signature help" },
  { "<leader>d",  vim.diagnostic.open_float,    desc = "Diagnostics float" },
  { "[d",         function() jump(-1) end,      desc = "Previous diagnostic" },
  { "]d",         function() jump(1) end,       desc = "Next diagnostic" },
  { "<leader>sd", vim.lsp.buf.document_symbol,  desc = "Document symbols" },
  { "<leader>sw", vim.lsp.buf.workspace_symbol, desc = "Workspace symbols" },
})

-- FzfLua
wk.add({
  { "<leader>/", cmd [[FzfLua grep_curbuf]], desc = "Grep current buffer" },
  { "<leader>b", cmd [[FzfLua buffers]],     desc = "Buffers" },
  { "<leader>g", cmd [[FzfLua live_grep]],   desc = "Live grep" },
  { "<leader>F", cmd [[FzfLua files]],       desc = "Find file" },
  { "<leader>o", cmd [[FzfLua oldfiles]],    desc = "Recent files" },
  { "<leader>r", cmd [[FzfLua resume]],      desc = "Resume search" },
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

-- Debugger
wk.add({
  { "<F5>",  cmd [[lua require'dap'.continue()]],          desc = "Start debug" },
  { "<F9>",  cmd [[lua require'dap'.toggle_breakpoint()]], desc = "Toggle breakpoint" },
  { "<F10>", cmd [[lua require'dap'.step_over()]],         desc = "Step over" },
  { "<F11>", cmd [[lua require'dap'.step_into()]],         desc = "Step into" },
  { "<F12>", cmd [[lua require'dap'.step_out()]],          desc = "Step out" },
  { "<M-e>", cmd [[lua require'dapui'.eval()]],            desc = "Evaluate expression", mode = { "n", "v" } },
})
