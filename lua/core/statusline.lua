local api = vim.api
local colors = require('utils.colors')
local string = require('utils.string')

vim.opt.laststatus = 3
vim.opt.showmode = false
vim.o.showtabline = 2

local MODE_HIGHLIGHTS = {
  Normal = 'DiagnosticInfo',
  Insert = 'DiagnosticOk',
  Visual = 'Statement',
  Command = 'DiagnosticWarn',
  Replace = 'DiagnosticError',
  Terminal = 'DiagnosticHint',
  Other = 'Special',
}

local MODES = {
  n = { label = 'NORMAL', hl = 'Normal' },
  i = { label = 'INSERT', hl = 'Insert' },
  v = { label = 'VISUAL', hl = 'Visual' },
  V = { label = 'V-LINE', hl = 'Visual' },
  ['\22'] = { label = 'V-BLOCK', hl = 'Visual' },
  c = { label = 'COMMAND', hl = 'Command' },
  r = { label = 'PROMPT', hl = 'Replace' },
  R = { label = 'REPLACE', hl = 'Replace' },
  t = { label = 'TERMINAL', hl = 'Terminal' },
  other = { hl = 'Other' },
}

local DIAGNOSTICS = {
  {
    severity = vim.diagnostic.severity.ERROR,
    icon = '\u{f057}',
    hl = 'DiagnosticError',
  },
  {
    severity = vim.diagnostic.severity.WARN,
    icon = '\u{f071}',
    hl = 'DiagnosticWarn',
  },
}

local GIT_ICON = '\u{f418}'
-- local RIGHT_SEPARATOR = ' \u{2502} '
local RIGHT_SEPARATOR = ' \u{00b7} '

-- Создаёт группы подсветки режимов на основе темы.
local function setup_highlights()
  local normal = api.nvim_get_hl(0, { name = 'Normal', link = false })
  local fg, bg = normal.fg or 0xffffff, normal.bg or 0x000000

  for name, source in pairs(MODE_HIGHLIGHTS) do
    local color = api.nvim_get_hl(0, { name = source, link = false }).fg

    api.nvim_set_hl(0, 'StatusLineMode' .. name, color and {
      fg = colors.get_more_contrast(color, fg, bg),
      bg = color,
      bold = true,
    } or {})
  end
end

setup_highlights()

-- Получает Git-ветку асинхронно и сохраняет её в переменной буфера.
local function fetch_git_branch(bufnr)
  if vim.bo[bufnr].buftype ~= '' or api.nvim_buf_get_name(bufnr) == '' then
    return
  end

  vim.b[bufnr].git_branch = ''

  local root = vim.fs.root(bufnr, '.git')
  if not root then
    return
  end

  vim.system(
    { 'git', '-C', root, 'branch', '--show-current' },
    { text = true },
    function(result)
      vim.schedule(function()
        if result.code == 0 and api.nvim_buf_is_valid(bufnr) then
          vim.b[bufnr].git_branch = vim.trim(result.stdout)
          vim.cmd.redrawstatus()
        end
      end)
    end
  )
end

local group = api.nvim_create_augroup('StatusLine', { clear = true })

api.nvim_create_autocmd('ColorScheme', {
  group = group,
  callback = setup_highlights,
})

-- Ветка запрашивается только один раз для каждого буфера.
api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(args)
    if vim.b[args.buf].git_branch == nil then
      fetch_git_branch(args.buf)
    end
  end,
})

-- Экранирует «%» в строках, выводимых через statusline.
local function escape(str)
  return (str:gsub('%%', '%%%%'))
end

-- Формирует счётчики ошибок и предупреждений.
local function get_diagnostics()
  local counts = vim.diagnostic.count(0)
  local parts = {}

  for _, item in ipairs(DIAGNOSTICS) do
    local count = counts[item.severity] or 0

    if count > 0 then
      parts[#parts + 1] = ('%%#%s#%s %d%%*'):format(item.hl, item.icon, count)
    end
  end

  return table.concat(parts, ' ')
end

-- Имена LSP-клиентов текущего буфера.
local function get_lsp_clients()
  return vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(client)
      return client.name
    end)
    :join(', ')
end

-- Git-ветка текущего буфера с иконкой.
local function get_git_branch()
  local branch = vim.b.git_branch or ''
  return branch ~= '' and (GIT_ICON .. ' ' .. branch) or ''
end

-- Название активной раскладки (keymap), если она включена.
local function get_keymap()
  return vim.bo.iminsert == 1 and (vim.b.keymap_name or vim.bo.keymap) or ''
end

-- Кодировка файла, если она не UTF-8.
local function get_encoding()
  local encoding = vim.bo.fileencoding
  return encoding:lower() ~= 'utf-8' and encoding or ''
end

-- Формирует статуслайн текущего окна.
function statusline()
  local mode_short = api.nvim_get_mode().mode
  local mode = MODES[mode_short:sub(1, 1)] or MODES.other

  local left = string.join_non_empty({
    ('%%#StatusLineMode%s# %s %%*'):format(mode.hl, mode.label or mode_short),
    get_git_branch(),
    get_diagnostics(),
  }, ' ')

  local right = string.join_non_empty({
    get_keymap(),
    get_lsp_clients(),
    vim.bo.filetype,
    get_encoding(),
    '%3l:%-3c ',
  }, RIGHT_SEPARATOR)

  return left .. '%=' .. right
end

-- %{ ... } выводит значение.
-- %{% ... %} дополнительно разбирает форматирование.
vim.opt.statusline = '%{%v:lua.statusline()%}'

-- Формирует TabLine из загруженных буферов.
function _G.get_buffers()
  local current = api.nvim_get_current_buf()
  local items, curr_idx, total = {}, 1, 0

  for _, bufnr in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local name = api.nvim_buf_get_name(bufnr)
      name = name ~= '' and vim.fs.basename(name) or '[No Name]'

      local text = name .. (vim.bo[bufnr].modified and '+' or '')
      local len = vim.fn.strdisplaywidth(' ' .. text .. ' ')
      total = total + len

      if bufnr == current then
        curr_idx = #items + 1
      end

      items[#items + 1] = {
        len = len,
        str = ('%%%d@v:lua.handle_buffer_click@%%#%s# %s %%*%%X'):format(
          bufnr,
          bufnr == current and 'TabLineSel' or 'TabLine',
          escape(text)
        ),
      }
    end
  end

  if #items == 0 then
    return ''
  end

  local l, r = 1, #items

  -- Не помещается: окно вокруг текущей вкладки.
  -- Под два маркера «…» резервируется по три ячейки.
  if total > vim.o.columns then
    local limit = vim.o.columns - 6
    local w = items[curr_idx].len
    l, r = curr_idx, curr_idx

    local grew = true
    while grew do
      grew = false

      if items[l - 1] and w + items[l - 1].len <= limit then
        l = l - 1
        w = w + items[l].len
        grew = true
      end

      if items[r + 1] and w + items[r + 1].len <= limit then
        r = r + 1
        w = w + items[r].len
        grew = true
      end
    end
  end

  local res = {}

  if l > 1 then
    res[#res + 1] = '%#TabLine# … %*'
  end

  for i = l, r do
    res[#res + 1] = items[i].str
  end

  if r < #items then
    res[#res + 1] = '%#TabLine# … %*'
  end

  return table.concat(res)
end

-- Левый клик переключает буфер, средний закрывает его.
function _G.handle_buffer_click(bufnr, _, button)
  if button == 'l' then
    api.nvim_set_current_buf(bufnr)
  elseif button == 'm' then
    api.nvim_buf_delete(bufnr, { force = false })
  end
end

vim.o.tabline = '%!v:lua.get_buffers()'
