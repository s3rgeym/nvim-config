local colors = require('utils.colors')

vim.o.laststatus = 3
vim.o.showmode = false

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
    icon = '',
    hl = 'DiagnosticError',
  },
  {
    severity = vim.diagnostic.severity.WARN,
    icon = '',
    hl = 'DiagnosticWarn',
  },
  {
    severity = vim.diagnostic.severity.INFO,
    icon = '',
    hl = 'DiagnosticInfo',
  },
  {
    severity = vim.diagnostic.severity.HINT,
    icon = '',
    hl = 'DiagnosticHint',
  },
}

local function setup_highlights()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local fg, bg = normal.fg or 0xffffff, normal.bg or 0x000000

  for name, source in pairs(MODE_HIGHLIGHTS) do
    local color = vim.api.nvim_get_hl(0, { name = source, link = false }).fg

    vim.api.nvim_set_hl(0, 'StatusLineMode' .. name, color and {
      fg = colors.get_more_contrast(color, fg, bg),
      bg = color,
      bold = true,
    } or {})
  end
end

setup_highlights()

local group = vim.api.nvim_create_augroup('StatusLine', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  callback = setup_highlights,
})

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

local function update_git_branch(buf)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf)) or '.'

  vim.system(
    { 'git', '-C', dir, 'branch', '--show-current' },
    { text = true },
    function(result)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        vim.b[buf].git_branch = result.code == 0 and vim.trim(result.stdout)
          or ''
      end)
    end
  )
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
  group = group,
  callback = function(args)
    update_git_branch(args.buf)
  end,
})

local function lsp_clients()
  local names = vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(client)
      return client.name
    end)
    :totable()

  return table.concat(names, ', ')
end

function _G.render_statusline()
  local mode_short = vim.api.nvim_get_mode().mode
  local mode = MODES[mode_short:sub(1, 1)] or MODES.other
  local branch = vim.b.git_branch or ''
  local keymap = vim.bo.iminsert == 1 and (vim.b.keymap_name or vim.bo.keymap)
    or ''
  local filetype = vim.bo.filetype
  local diagnostic = diagnostics()
  local lsp = lsp_clients()

  return table.concat({
    ('%%#StatusLineMode%s# %s %%*'):format(mode.hl, mode.label or mode_short),
    ' %f%m%r',
    branch ~= '' and '  ' .. branch or '',
    diagnostic ~= '' and ' ' .. diagnostic or '',
    '%=',
    keymap ~= '' and '  ' .. keymap or '',
    lsp ~= '' and '  ' .. lsp or '',
    -- filetype ~= '' and '  ' .. filetype or '',
    '  %3l:%-2c',
    '  %3p%% ',
  })
end

-- %{ ... } выводит значение.
-- %{% ... %} дополнительно разбирает форматирование и группы подсветки.
vim.o.statusline = '%{%v:lua.render_statusline()%}'
