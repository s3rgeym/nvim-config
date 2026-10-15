-- sudo pacman -S fzf ripgrep
-- Многофункциональный плагин на основе fzf
-- Лучше задать через .fzfrc
-- vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'
vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/ibhagwan/fzf-lua',
})

local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  -- fzf_colors = true,
  -- winopts = {
  --   border = 'rounded',
  -- },
  -- preview = {
  --   border = 'single',
  -- },
})

fzf_lua.register_ui_select()

local map = vim.keymap.set

-- Я решил не вешать ничего на сочетания типа <C-g>, <C-p> и тп, как советует
-- разработчик
-- Поиск и навигация
map('n', '<leader>ff', fzf_lua.files, { desc = 'FZF Files' })
map('n', '<leader>fg', fzf_lua.live_grep, { desc = 'FZF Grep' })
map('n', '<leader>f/', fzf_lua.lgrep_curbuf, { desc = 'FZF Buffer Search' })
map('n', '<leader>fw', fzf_lua.grep_cword, { desc = 'FZF Grep Word' })
map('n', '<leader>fb', fzf_lua.buffers, { desc = 'FZF Buffers' })
map('n', '<leader>fo', fzf_lua.oldfiles, { desc = 'FZF Old Files' })
map('n', '<leader>fr', fzf_lua.resume, { desc = 'FZF Resume' })

-- Код и диагностика
map(
  'n',
  '<leader>fs',
  fzf_lua.lsp_document_symbols,
  { desc = 'FZF Document Symbols' }
)
map(
  'n',
  '<leader>fS',
  fzf_lua.lsp_workspace_symbols,
  { desc = 'FZF Workspace Symbols' }
)
map(
  'n',
  '<leader>fd',
  fzf_lua.diagnostics_workspace,
  { desc = 'FZF Workspace Diagnostics' }
)
map(
  'n',
  '<leader>fD',
  fzf_lua.diagnostics_document,
  { desc = 'FZF Document Diagnostics' }
)

-- История и переходы
map('n', '<leader>fj', fzf_lua.jumps, { desc = 'FZF Jumplist' })
map(
  'n',
  '<leader>f:',
  fzf_lua.command_history,
  { desc = 'FZF Command History' }
)
map('n', '<leader>f?', fzf_lua.search_history, { desc = 'FZF Search History' })
map('n', '<leader>fm', fzf_lua.marks, { desc = 'FZF Marks' })
map('n', '<leader>fq', fzf_lua.quickfix, { desc = 'FZF Quickfix' })

-- Инструменты Neovim
map('n', '<leader>fc', fzf_lua.builtin, { desc = 'FZF Commands' })
map('n', '<leader>fk', fzf_lua.keymaps, { desc = 'FZF Keymaps' })
map('n', '<leader>fh', fzf_lua.helptags, { desc = 'FZF Help' })
map('n', '<leader>fu', fzf_lua.undotree, { desc = 'FZF Undotree' })
map('n', '<leader>ft', fzf_lua.colorschemes, { desc = 'FZF Themes' })

-- Git
map('n', '<leader>gf', fzf_lua.git_files, { desc = 'FZF Git Files' })
map('n', '<leader>gs', fzf_lua.git_status, { desc = 'FZF Git Status' })
map('n', '<leader>gc', fzf_lua.git_commits, { desc = 'FZF Git Commits' })
map(
  'n',
  '<leader>gC',
  fzf_lua.git_bcommits,
  { desc = 'FZF Git Buffer Commits' }
)
map('n', '<leader>gb', fzf_lua.git_branches, { desc = 'FZF Git Branches' })
map('n', '<leader>gB', fzf_lua.git_blame, { desc = 'FZF Git Blame' })
map('n', '<leader>gt', fzf_lua.git_tags, { desc = 'FZF Git Tags' })
map('n', '<leader>gS', fzf_lua.git_stash, { desc = 'FZF Git Stash' })
map('n', '<leader>gd', fzf_lua.git_diff, { desc = 'FZF Git Diff' })
map('n', '<leader>gh', fzf_lua.git_hunks, { desc = 'FZF Git Hunks' })

-- Переопределение встроенных сочетаний в Neovim 0.10+
-- https://neovim.io/doc/user/lsp/#_defaults
map({ 'n', 'v' }, 'gra', fzf_lua.lsp_code_actions, { desc = 'Code Action' })
map('n', 'grr', fzf_lua.lsp_references, { desc = 'References' })
map('n', 'gri', fzf_lua.lsp_implementations, { desc = 'Implementations' })
map('n', 'grt', fzf_lua.lsp_typedefs, { desc = 'Type Definition' })
-- map(
--   'n',
--   'gO',
--   fzf_lua.lsp_document_symbols,
--   { desc = 'Document Symbols' }
-- )

-- Замена встроенно автодополнения файлов, которое завершается при выборе
-- сегмента пути, что не очень удобно
map({ 'i' }, '<C-x><C-f>', function()
  fzf_lua.complete_file({
    cmd = 'rg --files',
    winopts = { preview = { hidden = true } },
  })
end, { silent = true, desc = 'Fuzzy complete file' })
