local color_utils = require('utils.color')

local MODE_GROUP_PREFIX = 'StatusLineMode'
local LOCATION_GROUP = 'StatusLineLocation'
local AUGROUP_NAME = 'StatusLineHighlights'

-- vim.g.terminal_color_N не доступны в catppuccin.
-- Стиль режима -> группа темы, из fg которой берётся фон блока.
local MODE_COLOR_SOURCES = {
  Normal = 'Function',
  Insert = 'String',
  Visual = 'Statement',
  Command = 'Constant',
  Replace = 'DiagnosticError',
  Terminal = 'DiagnosticInfo',
  Other = 'Comment',
}

-- Результат vim.fn.mode() -> название и стиль режима.
local MODES = {
  n = { label = 'NORMAL', style = 'Normal' },
  i = { label = 'INSERT', style = 'Insert' },
  v = { label = 'VISUAL', style = 'Visual' },
  V = { label = 'V-LINE', style = 'Visual' },
  ['\22'] = { label = 'V-BLOCK', style = 'Visual' },
  c = { label = 'COMMAND', style = 'Command' },
  R = { label = 'REPLACE', style = 'Replace' },
  t = { label = 'TERMINAL', style = 'Terminal' },
  other = { style = 'Other' },
}

-- Глобальная: нужна для вызова через v:lua в 'statusline'.
StatusLine = {}

-- Возвращает атрибуты highlight-группы с разрешёнными ссылками.
local function get_highlight(group)
  return vim.api.nvim_get_hl(0, {
    name = group,
    link = false,
  })
end

-- Возвращает имя highlight-группы для стиля режима.
local function get_mode_group(style)
  return MODE_GROUP_PREFIX .. style
end

-- Возвращает цвет текста с максимальным контрастом к фону.
local function get_contrast_fg(background, normal_hl)
  return color_utils.get_more_contrast(
    background,
    normal_hl.fg or 0xFFFFFF,
    normal_hl.bg or 0x000000
  )
end

-- Создаёт highlight-группу цветного блока.
-- Без цвета очищает группу, чтобы не остались цвета предыдущей темы.
local function set_block_highlight(group, background, base_hl, normal_hl)
  if not background then
    vim.api.nvim_set_hl(0, group, {})
    return
  end

  vim.api.nvim_set_hl(
    0,
    group,
    vim.tbl_extend('force', base_hl or {}, {
      fg = get_contrast_fg(background, normal_hl),
      bg = background,
      bold = true,
    })
  )
end

-- Обновляет цвета блоков на основе highlight-групп текущей темы.
local function update_highlights()
  local normal_hl = get_highlight('Normal')
  local location_hl = get_highlight('PmenuSel')

  for style, source_group in pairs(MODE_COLOR_SOURCES) do
    local source_hl = get_highlight(source_group)

    set_block_highlight(get_mode_group(style), source_hl.fg, nil, normal_hl)
  end

  set_block_highlight(LOCATION_GROUP, location_hl.bg, location_hl, normal_hl)
end

-- Возвращает название текущего режима с его подсветкой.
-- Вызывать через '%{%v:lua.StatusLine.mode_block()%}'.
function StatusLine.mode_block()
  local mode = vim.fn.mode()
  local info = MODES[mode:sub(1, 1)] or MODES.other

  return string.format(
    '%%#%s# %s %%*',
    get_mode_group(info.style),
    info.label or mode
  )
end

-- Возвращает имена LSP-клиентов текущего буфера.
-- Вызывать через '%{v:lua.StatusLine.lsp_clients()}'.
function StatusLine.lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    return 'n/a'
  end

  local names = {}

  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end

  return table.concat(names, ', ')
end

-- Повторно создаём группы при смене цветовой схемы.
local augroup = vim.api.nvim_create_augroup(AUGROUP_NAME, {
  clear = true,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  desc = 'Update statusline highlights',
  callback = update_highlights,
})

-- Тема могла быть загружена до этого файла.
update_highlights()

vim.opt.statusline = table.concat({
  '%{%v:lua.StatusLine.mode_block()%}',
  ' %<%t%m%r',
  ' %{%v:lua.vim.ui.progress_status()%}',
  '%=',
  '%k',
  ' %{%v:lua.vim.diagnostic.status()%}',
  ' %{v:lua.StatusLine.lsp_clients()}',
  ' %#' .. LOCATION_GROUP .. '# %3l:%-2v %*',
})
