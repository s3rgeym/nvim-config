local api = vim.api
local strwidth = api.nvim_strwidth
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
  Prompt = 'DiagnosticError',
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
  r = { label = 'PROMPT', hl = 'Prompt' },
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
  {
    severity = vim.diagnostic.severity.INFO,
    icon = '\u{f05a}',
    hl = 'DiagnosticInfo',
  },
  {
    severity = vim.diagnostic.severity.HINT,
    icon = '\u{f0eb}',
    hl = 'DiagnosticHint',
  },
}

local GIT_ICON = '\u{f418}'
local RIGHT_SEPARATOR = ' \u{00b7} '
local MORE_MARKER = ' \u{2026} '
local MORE_MARKER_W = strwidth(MORE_MARKER)

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

api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(args)
    if vim.b[args.buf].git_branch == nil then
      fetch_git_branch(args.buf)
    end
  end,
})

local function escape(str)
  return (str:gsub('%%', '%%%%'))
end

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

local function get_lsp_clients()
  return vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(c)
      return c.name
    end)
    :join(', ')
end

local function get_git_branch()
  local branch = vim.b.git_branch or ''
  return branch ~= '' and (GIT_ICON .. ' ' .. branch) or ''
end

local function get_keymap()
  return vim.bo.iminsert == 1 and (vim.b.keymap_name or vim.bo.keymap) or ''
end

local function get_encoding()
  local enc = vim.bo.fileencoding
  return enc:lower() ~= 'utf-8' and enc or ''
end

function _G.render_statusline()
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
    '%3l:%-3c',
  }, RIGHT_SEPARATOR)

  return left .. '%=' .. right
end

-- %{ ... } выводит значение.
-- %{% ... %} дополнительно разбирает форматирование и группы подсветки.
vim.opt.statusline = '%{%v:lua.render_statusline()%}'

local function get_label(buf)
  local name = api.nvim_buf_get_name(buf)
  local label = name == '' and '[No Name]' or vim.fs.basename(name)
  return vim.bo[buf].modified and label .. ' [+]' or label
end

function _G.handle_buffer_click(bufnr, _, button)
  if button ~= 'l' or not api.nvim_buf_is_valid(bufnr) then
    return
  end
  api.nvim_set_current_buf(bufnr)
end

function _G.render_tabline()
  local buffers = vim.tbl_filter(function(buf)
    return vim.bo[buf].buflisted
  end, api.nvim_list_bufs())

  local count = #buffers
  if count == 0 then
    return ''
  end

  -- Проход 1: подписи и ширины
  local labels, widths = {}, {}
  local total = 0
  for i, buf in ipairs(buffers) do
    labels[i] = get_label(buf)
    widths[i] = strwidth(labels[i]) + 2
    total = total + widths[i]
  end

  local current = api.nvim_get_current_buf()
  local columns = vim.o.columns

  -- Проход 2: разбивка на страницы
  local items = {}
  local width = 0
  local rest = total -- суммарная ширина буферов i..count
  local has_current = false
  local tail_fits = false
  local start_idx = 1
  local end_idx = count

  for i, buf in ipairs(buffers) do
    local w = widths[i]
    local was_current = has_current
    has_current = has_current or buf == current

    -- место под правый маркер нужно, пока за этим буфером есть ещё буферы
    local limit = columns - (i < count and MORE_MARKER_W or 0)

    if not tail_fits and width + w > limit then
      if width + rest <= columns then
        tail_fits = true -- весь хвост влезает без правого маркера
      else
        if was_current then
          end_idx = i - 1
          break
        end
        -- новая страница не первая, значит под левый маркер уже занято место
        start_idx = i
        width = MORE_MARKER_W
        items = {}
      end
    end

    width = width + w
    rest = rest - w
    items[#items + 1] = ('%%%d@v:lua.handle_buffer_click@%%#%s# %s %%T'):format(
      buf,
      buf == current and 'TabLineSel' or 'TabLine',
      escape(labels[i])
    )
  end

  if start_idx > 1 then
    table.insert(items, 1, '%#TabLineFill#' .. escape(MORE_MARKER))
  end
  if end_idx < count then
    items[#items + 1] = '%#TabLineFill#' .. escape(MORE_MARKER)
  end

  return table.concat(items) .. '%#TabLineFill#'
end

vim.o.showtabline = 2
vim.o.tabline = '%!v:lua.render_tabline()'
