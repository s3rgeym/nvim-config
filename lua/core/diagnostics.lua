-- Можно вынести в after/plugin/ чтобы плагины не переопределяли настройки
vim.diagnostic.config({
  virtual_text = { source = 'if_many', spacing = 0, prefix = '' },
  signs = true,
  -- Ломает стандартную диагностику в статусе
  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = '',
  --     [vim.diagnostic.severity.WARN] = '',
  --     [vim.diagnostic.severity.INFO] = '',
  --     [vim.diagnostic.severity.HINT] = '',
  --   },
  -- },
  update_in_insert = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  float = {
    border = 'rounded',
    source = 'if_many',
  },
})

-- Ошибки в всплывающем окне при наведении мешают вызывать справку
-- vim.diagnostic.config({
--   virtual_text = false,
--   signs = true,
--   underline = true,
--   severity_sort = true,
--   float = { border = 'rounded', source = true },
-- })
--
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
-- })
