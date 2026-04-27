local theme_file = vim.fn.stdpath('config') .. '/theme.json'
local fallback = 'habamax'

local function load_theme()
  local f = io.open(theme_file, 'r')
  if not f then
    return nil
  end
  local content = f:read('*a')
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  return ok and data.colorscheme or nil
end

local function save_theme(theme)
  local json = vim.fn.json_encode({ colorscheme = theme })
  vim.fn.writefile({ json }, theme_file)
end

-- Автоматическое сохранение темы при ее установке
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function(args)
    if args.match ~= load_theme() then
      save_theme(args.match)
    end
  end,
})

-- Применяем тему после загрузки всех плагинов из rtp/plugin и rtp/after/plugin
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local cs = load_theme() or fallback
    if not pcall(vim.cmd.colorscheme, cs) then
      pcall(vim.cmd.colorscheme, fallback)
    end
  end,
})
