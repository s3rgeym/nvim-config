local theme_module = 'config.current-theme'
local theme_file = vim.fn.stdpath('config')
  .. '/lua/'
  .. theme_module:gsub('%.', '/')
  .. '.lua'

local function load_theme()
  -- Сбрасываем кэш require, чтобы всегда читать актуальный файл
  package.loaded[theme_module] = nil

  local ok, theme = pcall(require, theme_module)

  if ok and type(theme) == 'string' then
    pcall(vim.cmd.colorscheme, theme)
  end
end

local group = vim.api.nvim_create_augroup('ThemePersistence', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  desc = 'Save the current colorscheme',
  callback = function(args)
    -- Избегаем бесконечной перезаписи, если имя темы пустое
    if args.match and args.match ~= '' then
      local f = assert(io.open(theme_file, 'w'))
      f:write(string.format('return %q\n', args.match))
      f:close()
    end
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Load the saved colorscheme',
  callback = load_theme,
})
