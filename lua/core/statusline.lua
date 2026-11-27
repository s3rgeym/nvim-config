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
  Replace = 'DiagnosticError',
  Other = 'DiagnosticHint',
}

local MODES = {
  n = { label = 'NORMAL', hl = 'Normal' },
  i = { label = 'INSERT', hl = 'Insert' },
  v = { label = 'VISUAL', hl = 'Visual' },
  V = { label = 'V-LINE', hl = 'Visual' },
  ['\22'] = { label = 'V-BLOCK', hl = 'Visual' },
  c = { label = 'COMMAND', hl = 'Command' },
  R = { label = 'REPLACE', hl = 'Replace' },
  t = { label = 'TERMINAL', hl = 'Other' },
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

local function escape(value)
  return (value:gsub('%%', '%%%%'))
end

local function setup_highlights()
  local normal = api.nvim_get_hl(0, {
    name = 'Normal',
    link = false,
  })

  local statusline = api.nvim_get_hl(0, {
    name = 'StatusLine',
    link = false,
  })

  local normal_fg = normal.fg or 0xffffff
  local normal_bg = normal.bg or 0x000000
  local statusline_bg = statusline.bg or normal_bg

  for name, source in pairs(MODE_HIGHLIGHTS) do
    local background = api.nvim_get_hl(0, {
      name = source,
      link = false,
    }).fg

    api.nvim_set_hl(0, 'StatusLineMode' .. name, background and {
      fg = colors.get_more_contrast(background, normal_fg, normal_bg),
      bg = background,
      bold = true,
    } or {})

    api.nvim_set_hl(0, 'StatusLineModeSep' .. name, background and {
      fg = background,
      bg = statusline_bg,
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
  return branch ~= '' and (' %s'):format(escape(branch)) or ''
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

  return table.concat(parts, ' ')
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

  return table.concat(parts, ' ')
end

local function lsp_clients()
  local names = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = escape(client.name)
  end

  return #names > 0 and ' ' .. table.concat(names, ', ') or ''
end

local function keymap()
  local name = vim.bo.iminsert == 1 and (vim.b.keymap_name or vim.bo.keymap)
    or ''
  return name ~= '' and '  ' .. escape(name) or ''
end

local function filetype()
  return vim.bo.filetype ~= '' and (' ' .. escape(vim.bo.filetype)) or ''
end

local function encoding()
  return escape(
    (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
  )
end

local function fileformat()
  return ({
    unix = '',
    dos = '',
    mac = '',
  })[vim.bo.fileformat] or vim.bo.fileformat
end

function _G.render_statusline()
  local raw_mode = api.nvim_get_mode().mode
  local mode = MODES[raw_mode:sub(1, 1)]
  local hl_name = mode and mode.hl or 'Other'
  local hl = 'StatusLineMode' .. hl_name
  local sep_hl = 'StatusLineModeSep' .. hl_name

  return vim
    .iter({
      ('%%#%s# %s %%*%%#%s#%%*'):format(
        hl,
        mode and mode.label or raw_mode,
        sep_hl
      ),
      '%<%f%m%r', -- Замени %f на %t, если нужно только имя файла
      git_branch(),
      git_changes(),
      '%=',
      keymap(),
      diagnostics(),
      lsp_clients(),
      filetype(),
      -- encoding(),
      -- fileformat(),
      -- ('%%#%s#%%*%%#%s# %%3p%%%%  %%3l:%%02c %%*'):format(sep_hl, hl),
      ('%%#%s#%%*%%#%s# %%3l:%%02c %%*'):format(sep_hl, hl),
    })
    :filter(function(x)
      return x ~= ''
    end)
    :join(' ')
end

-- %{% ... %} в отличии от %{ ... } дополнительно разбирает форматирование
vim.o.statusline = '%{%v:lua.render_statusline()%}'
