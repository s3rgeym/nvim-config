-- Автоматически сохраняет и загружает цветовую схему,
-- установленную через :colorscheme.
local theme_file = vim.fn.stdpath('config') .. '/theme.json'
local fallback = 'habamax'

local function load_theme()
  local f = io.open(theme_file, 'r')
  if not f then
    return
  end

  local ok, data = pcall(vim.json.decode, f:read('*a'))
  f:close()

  return ok and type(data) == 'table' and data.colorscheme or nil
end

local function save_theme(theme)
  local json = vim.fn.json_encode({ colorscheme = theme })
  pcall(vim.fn.writefile, { json }, theme_file)
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Save selected color scheme to JSON file',
  callback = function(args)
    save_theme(args.match)
  end,
})

-- VimEnter необходим, так как плагины из ~/.config/nvim/plugin
-- загружаются после init.lua. Поэтому пользовательская тема может
-- быть применена только после того, как все плагины добавили свои темы.
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load saved color scheme after all plugins are loaded',
  callback = function()
    local theme = load_theme() or fallback

    if not pcall(vim.cmd.colorscheme, theme) then
      vim.cmd.colorscheme(fallback)
      save_theme(fallback)
    end
  end,
})
