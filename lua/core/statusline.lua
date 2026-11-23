local colors = require('utils.colors')

vim.o.laststatus = 3
vim.o.showmode = false

local api = vim.api
local severity = vim.diagnostic.severity

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
  { severity = severity.ERROR, icon = '', hl = 'DiagnosticError' },
  { severity = severity.WARN, icon = '', hl = 'DiagnosticWarn' },
  { severity = severity.INFO, icon = '', hl = 'DiagnosticInfo' },
  { severity = severity.HINT, icon = '', hl = 'DiagnosticHint' },
}

local GIT_CHANGES = {
  { key = 'added', sign = '+', hl = 'DiagnosticOk' },
  { key = 'modified', sign = '~', hl = 'DiagnosticWarn' },
  { key = 'deleted', sign = '-', hl = 'DiagnosticError' },
  { key = 'untracked', sign = '?', hl = 'DiagnosticInfo' },
  { key = 'conflicted', sign = '!', hl = 'DiagnosticError' },
}

local function escape_statusline(value)
  return (value:gsub('%%', '%%%%'))
end

local function setup_highlights()
  local normal = api.nvim_get_hl(0, {
    name = 'Normal',
    link = false,
  })

  local fg = normal.fg or 0xffffff
  local bg = normal.bg or 0x000000

  for name, source in pairs(MODE_HIGHLIGHTS) do
    local color = api.nvim_get_hl(0, {
      name = source,
      link = false,
    }).fg

    api.nvim_set_hl(0, 'StatusLineMode' .. name, color and {
      fg = colors.get_more_contrast(color, fg, bg),
      bg = color,
      bold = true,
    } or {})
  end
end

setup_highlights()

local group = api.nvim_create_augroup('StatusLine', { clear = true })

api.nvim_create_autocmd('ColorScheme', {
  group = group,
  callback = setup_highlights,
})

local function update_git_status(buf)
  local conflicts = { DD = 1, AU = 1, UD = 1, UA = 1, DU = 1, AA = 1, UU = 1 }
  local dir = vim.fs.dirname(api.nvim_buf_get_name(buf)) or '.'
  local id = (vim.b[buf].git_update_id or 0) + 1
  vim.b[buf].git_update_id = id

  vim.system(
    { 'git', '-C', dir, 'status', '--porcelain=v1', '--branch' },
    { text = true },
    vim.schedule_wrap(function(r)
      if not api.nvim_buf_is_valid(buf) or vim.b[buf].git_update_id ~= id then
        return
      end

      local branch, status = '', nil
      if r.code == 0 then
        status = {
          added = 0,
          modified = 0,
          deleted = 0,
          untracked = 0,
          conflicted = 0,
        }
        for line in r.stdout:gmatch('[^\r\n]+') do
          if line:sub(1, 2) == '##' then
            branch = line:match('^## No commits yet on (.+)')
              or line:match('^## (.-)%.%.%.')
              or line:match('^## (.+)$')
            if branch:match('^HEAD ') then
              branch = ''
            end
          else
            local xy = line:sub(1, 2)
            local key = xy == '??' and 'untracked'
              or conflicts[xy] and 'conflicted'
              or xy:find('D') and 'deleted'
              or xy:find('A') and 'added'
              or 'modified'
            status[key] = status[key] + 1
          end
        end
      end

      vim.b[buf].git_branch = branch
      vim.b[buf].git_status = status
      vim.cmd.redrawstatus()
    end)
  )
end

api.nvim_create_autocmd({
  'BufEnter',
  'FocusGained',
  'BufWritePost',
}, {
  group = group,
  callback = function(args)
    update_git_status(args.buf)
  end,
})

local function git_branch()
  local branch = vim.b.git_branch or ''

  return branch ~= ''
      and ('%%#PmenuSel#  %s %%*'):format(escape_statusline(branch))
    or ''
end

local function git_changes()
  local status = vim.b.git_status

  if not status then
    return ''
  end

  local parts = {}
  for _, item in ipairs(GIT_CHANGES) do
    local count = status[item.key]

    if count > 0 then
      parts[#parts + 1] = ('%%#%s#%s%d%%*'):format(item.hl, item.sign, count)
    end
  end

  return #parts > 0 and ' ' .. table.concat(parts, ' ') or ''
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local parts = {}

  for _, item in ipairs(DIAGNOSTICS) do
    local count = counts[item.severity] or 0

    if count > 0 then
      parts[#parts + 1] = ('%%#%s#%s %d%%*'):format(item.hl, item.icon, count)
    end
  end

  return #parts > 0 and ' ' .. table.concat(parts, ' ') or ''
end

local function lsp_clients()
  local names = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = escape_statusline(client.name)
  end

  -- table.sort(names)

  return #names > 0 and '  ' .. table.concat(names, ', ') or ''
end

local function keymap()
  if vim.bo.iminsert ~= 1 then
    return ''
  end

  local name = vim.b.keymap_name or vim.bo.keymap

  return name ~= '' and '  ' .. escape_statusline(name) or ''
end

function _G.render_statusline()
  local mode_short = api.nvim_get_mode().mode
  local mode = MODES[mode_short:sub(1, 1)] or MODES.other
  local mode_hl = 'StatusLineMode' .. mode.hl

  return table.concat({
    ('%%#%s# %s %%*'):format(mode_hl, mode.label or mode_short),
    git_branch(),
    git_changes(),
    ' %<%{pathshorten(expand("%:~"))}%m%r',
    '%=',
    keymap(),
    diagnostics(),
    lsp_clients(),
    ' %#PmenuSel# %3p%% %*',
    ('%%#%s# %%3l:%%-2c %%*'):format(mode_hl),
  })
end

-- %{% ... %} в отличии от %{ ... } дополнительно разбирает форматирование
vim.o.statusline = '%{%v:lua.render_statusline()%}'
