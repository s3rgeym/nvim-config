local color = require('utils.color')

local HIGHLIGHT_PREFIX = 'StatusLineMode'

-- vim.g.terminal_color_N не доступны в catppuccin
local MODE_THEME_MAPPING = {
  Normal = 'Function',
  Insert = 'String',
  Visual = 'Statement',
  Command = 'Constant',
  Replace = 'DiagnosticError',
  Terminal = 'DiagnosticInfo',
  Comment = 'Comment',
  Other = 'Comment',
}

local MODES = {
  n = {
    label = 'NORMAL',
    hl_group = 'Normal',
  },
  i = {
    label = 'INSERT',
    hl_group = 'Insert',
  },
  v = {
    label = 'VISUAL',
    hl_group = 'Visual',
  },
  V = {
    label = 'V-LINE',
    hl_group = 'Visual',
  },
  ['\22'] = {
    label = 'V-BLOCK',
    hl_group = 'Visual',
  },
  c = {
    label = 'COMMAND',
    hl_group = 'Command',
  },
  R = {
    label = 'REPLACE',
    hl_group = 'Replace',
  },
  t = {
    label = 'TERMINAL',
    hl_group = 'Terminal',
  },
  other = {
    hl_group = 'Other',
  },
}

local augroup = vim.api.nvim_create_augroup('StatusLineModes', {})
local active_hl_groups = {}

StatusLine = {}

-- Возвращает полное имя собственной highlight-группы.
local function hl_group(entry)
  return HIGHLIGHT_PREFIX .. entry.hl_group
end

-- Возвращает название режима с его подсветкой.
-- Вызывать через '%{%v:lua.StatusLine.mode_name()%}'.
function StatusLine.mode_name()
  local mode = vim.fn.mode()
  local entry = MODES[mode:sub(1, 1)] or MODES.other
  local label = entry.label or mode
  local group = hl_group(entry)

  if not active_hl_groups[group] then
    return string.format(' %s ', label)
  end

  return string.format('%%#%s# %s %%*', group, label)
end

function StatusLine.lsp_client_names()
  local names = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = client.name
  end

  return table.concat(names, ', ')
end

-- Создаёт highlight-группы на основе цветов текущей темы.
local function update_highlights()
  local normal_hl = vim.api.nvim_get_hl(0, {
    name = 'Normal',
    link = false,
  })

  local normal_fg = normal_hl.fg or 0xFFFFFF
  local normal_bg = normal_hl.bg or 0x000000

  active_hl_groups = {}

  for _, entry in pairs(MODES) do
    local group = hl_group(entry)
    local source_name = MODE_THEME_MAPPING[entry.hl_group]
      or MODE_THEME_MAPPING.Other

    local source_hl = vim.api.nvim_get_hl(0, {
      name = source_name,
      link = true,
    })

    local background = source_hl.fg

    if background then
      vim.api.nvim_set_hl(0, group, {
        fg = color.get_more_contrast(background, normal_fg, normal_bg),
        bg = background,
        bold = true,
      })

      active_hl_groups[group] = true
    else
      -- Удаляем цвета предыдущей темы, если исходная группа отсутствует.
      vim.api.nvim_set_hl(0, group, {})
    end
  end
end

-- Повторно создаём группы при смене цветовой схемы.
vim.api.nvim_clear_autocmds({
  group = augroup,
  event = 'ColorScheme',
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  desc = 'Update statusline mode highlights',
  callback = update_highlights,
})

-- Тема могла быть загружена до этого файла.
update_highlights()

vim.opt.statusline = table.concat({
  '%{%v:lua.StatusLine.mode_name()%}',
  ' %<%t%m%r',
  ' %{%v:lua.vim.ui.progress_status()%}',
  '%=',
  '%k',
  ' %{%v:lua.vim.diagnostic.status()%}',
  ' %{v:lua.StatusLine.lsp_client_names()}',
  ' %3l:%-2v ',
})
