-- Можно вынести в after/plugin/ чтобы плагины не переопределяли настройки
vim.diagnostic.config({
  virtual_text = {
    source = true,
    spacing = 0,
    -- prefix = function(diagnostic)
    --   local icons = {
    --     [vim.diagnostic.severity.ERROR] = '',
    --     [vim.diagnostic.severity.WARN] = '',
    --     [vim.diagnostic.severity.INFO] = '',
    --     [vim.diagnostic.severity.HINT] = '',
    --   }
    --   return icons[diagnostic.severity]
    -- end,
    prefix = '',
  },
  -- signs = {
  --   severity = vim.diagnostic.severity.WARN,
  -- },
  signs = true,
  update_in_insert = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  severity_sort = true,
  float = {
    -- Вроде от глобальных настроек наследуется
    -- border = 'rounded',
    source = true,
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
