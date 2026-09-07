-- sudo pacman -S fzf
-- Многофункциональный плагин на основе fzf
-- Лучше задать через .fzfrc
-- vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  fzf_colors = true,
  -- winopts = {
  --   border = 'rounded',
  -- },
  -- preview = {
  --   border = 'single',
  -- },
})

fzf_lua.register_ui_select()

-- Я решил не вешать ничего на сочетания типа <C-g>, <C-p> и тп, как советует
-- разработчик
vim.keymap.set('n', '<leader>ff', fzf_lua.files, { desc = 'FZF Files' })
vim.keymap.set('n', '<leader>fg', fzf_lua.live_grep, { desc = 'FZF Grep' })
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers, { desc = 'FZF Buffers' })
vim.keymap.set(
  'n',
  '<leader>fo',
  fzf_lua.oldfiles,
  { desc = 'FZF Recent Files' }
)
vim.keymap.set('n', '<leader>fr', fzf_lua.resume, { desc = 'FZF Resume' })
vim.keymap.set(
  'n',
  '<leader>fd',
  fzf_lua.diagnostics_workspace,
  { desc = 'FZF Workspace Diagnostics' }
)
vim.keymap.set('n', '<leader>fc', fzf_lua.builtin, { desc = 'FZF Commands' })
vim.keymap.set('n', '<leader>fk', fzf_lua.keymaps, { desc = 'FZF Keymaps' })
vim.keymap.set('n', '<leader>fj', fzf_lua.jumps, { desc = 'FZF Jumplist' })
vim.keymap.set('n', '<leader>fm', fzf_lua.marks, { desc = 'FZF Marks' })
vim.keymap.set('n', '<leader>fu', fzf_lua.undotree, { desc = 'FZF Undotree' })
vim.keymap.set('n', '<leader>ft', fzf_lua.colorschemes, { desc = 'FZF Themes' })

-- Переопределение встроенных сочетаний в Neovim 0.10+
vim.keymap.set(
  { 'n', 'v' },
  'gra',
  fzf_lua.lsp_code_actions,
  { desc = 'Code Action' }
)
vim.keymap.set('n', 'grr', fzf_lua.lsp_references, { desc = 'References' })
vim.keymap.set(
  'n',
  'gri',
  fzf_lua.lsp_implementations,
  { desc = 'Implementations' }
)
vim.keymap.set('n', 'grt', fzf_lua.lsp_typedefs, { desc = 'Type Definition' })
vim.keymap.set(
  'n',
  'gO',
  fzf_lua.lsp_document_symbols,
  { desc = 'Document Symbols' }
)

-- Замена встроенно автодополнения файлов, которое завершается при выборе
-- сегмента пути, что не очень удобно
vim.keymap.set({ 'i' }, '<C-x><C-f>', function()
  fzf_lua.complete_file({
    cmd = 'rg --files',
    winopts = { preview = { hidden = true } },
  })
end, { silent = true, desc = 'Fuzzy complete file' })
