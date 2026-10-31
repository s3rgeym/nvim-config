local colors = require('utils.colors')

vim.opt.laststatus = 3
vim.opt.showmode = false

local MODES = {
  n = { label = 'NORMAL', hl = 'Normal', source = 'DiagnosticInfo' },
  i = { label = 'INSERT', hl = 'Insert', source = 'DiagnosticOk' },
  v = { label = 'VISUAL', hl = 'Visual', source = 'Statement' },
  V = { label = 'V-LINE', hl = 'Visual', source = 'Statement' },
  ['\22'] = { label = 'V-BLOCK', hl = 'Visual', source = 'Statement' },
  c = { label = 'COMMAND', hl = 'Command', source = 'DiagnosticWarn' },
  r = { label = 'PROMPT', hl = 'Command', source = 'DiagnosticError' },
  R = { label = 'REPLACE', hl = 'Replace', source = 'DiagnosticError' },
  t = { label = 'TERMINAL', hl = 'Terminal', source = 'DiagnosticHint' },
  other = { hl = 'Other', source = 'Special' },
}

local DIAGNOSTICS = {
  {
    severity = vim.diagnostic.severity.ERROR,
    label = 'E',
    hl = 'DiagnosticError',
  },
  {
    severity = vim.diagnostic.severity.WARN,
    label = 'W',
    hl = 'DiagnosticWarn',
  },
}

local GIT_ICON = '\u{f418}'

local function get_hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function set_highlights()
  local normal = get_hl('Normal')
  local normal_fg = normal.fg or 0xffffff
  local normal_bg = normal.bg or 0x000000

  for _, mode in pairs(MODES) do
    local group = 'StatusLineMode' .. mode.hl
    local bg = get_hl(mode.source).fg

    if bg then
      vim.api.nvim_set_hl(0, group, {
        fg = colors.get_more_contrast(bg, normal_fg, normal_bg),
        bg = bg,
        bold = true,
      })
    else
      vim.api.nvim_set_hl(0, group, {})
    end
  end
end

-- Ветка определяется один раз на буфер и хранится в vim.b[bufnr].git_branch
-- nil = ещё не определяли, '' = ветки нет
local function update_git_branch(bufnr)
  if vim.bo[bufnr].buftype ~= '' or vim.api.nvim_buf_get_name(bufnr) == '' then
    return
  end

  -- Маркер ставим сразу, чтобы повторные BufEnter не запускали git заново
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
        if result.code ~= 0 or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        vim.b[bufnr].git_branch = vim.trim(result.stdout)
        vim.cmd.redrawstatus()
      end)
    end
  )
end

local function hl(group, text)
  return '%#' .. group .. '#' .. text .. '%*'
end

local function diagnostic_counts()
  local counts = vim.diagnostic.count(0)
  local parts = {}

  for _, item in ipairs(DIAGNOSTICS) do
    local count = counts[item.severity]

    if count then
      parts[#parts + 1] = hl(item.hl, item.label .. ':' .. count)
    end
  end

  return table.concat(parts, ' ')
end

local function lsp_names()
  return vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(client)
      return client.name
    end)
    :join(', ')
end

local function statusline()
  local mode_code = vim.api.nvim_get_mode().mode
  local mode = MODES[mode_code:sub(1, 1)] or MODES.other
  local mode_hl = 'StatusLineMode' .. mode.hl
  local branch = vim.b.git_branch or ''

  return table.concat({
    hl(mode_hl, ' ' .. (mode.label or mode_code) .. ' '),
    hl('CursorLine', ' %<%f%m%r '),
    branch ~= '' and (' ' .. GIT_ICON .. ' ' .. branch) or '',
    '%=%k ',
    diagnostic_counts(),
    ' ',
    lsp_names(),
    ' ',
    -- hl('PmenuSel', ' %3p%% '),
    hl(mode_hl, ' %3l:%-3c '),
  }, '')
end

_G.statusline = statusline

local group = vim.api.nvim_create_augroup('StatusLine', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  callback = set_highlights,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(args)
    if vim.b[args.buf].git_branch == nil then
      update_git_branch(args.buf)
    end
  end,
})

set_highlights()

-- %{ ... } выводит значение
-- %{% ... %} дополнительно разбирает форматирование
vim.opt.statusline = '%{%v:lua.statusline()%}'
