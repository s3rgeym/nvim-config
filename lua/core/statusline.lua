local color_utils = require('utils.color')

local MODE_GROUP_PREFIX = 'StatusLineMode'
local LOCATION_GROUP = 'StatusLineLocation'

-- Название цвета -> hex. Не зависит от темы.
local COLORS = {
  blue = 0x7aa2f7,
  green = 0x9ece6a,
  purple = 0xbb9af7,
  orange = 0xff9e64,
  red = 0xf7768e,
  gray = 0x565f89,
}

-- Результат vim.fn.mode() -> название режима, цвет из COLORS
-- и суффикс highlight-группы (без префикса).
local MODES = {
  n = { label = 'NORMAL', color = 'blue', group = 'Normal' },
  i = { label = 'INSERT', color = 'green', group = 'Insert' },
  v = { label = 'VISUAL', color = 'purple', group = 'Visual' },
  V = { label = 'V-LINE', color = 'purple', group = 'Visual' },
  ['\22'] = { label = 'V-BLOCK', color = 'purple', group = 'Visual' },
  c = { label = 'COMMAND', color = 'orange', group = 'Command' },
  R = { label = 'REPLACE', color = 'red', group = 'Replace' },
  t = { label = 'TERMINAL', color = 'gray', group = 'Other' },
  other = { color = 'gray', group = 'Other' },
}

local augroup = vim.api.nvim_create_augroup('StatusLineHighlights', {})

-- Глобальная: нужна для вызова через v:lua в 'statusline'.
StatusLine = {}

-- Возвращает полное имя highlight-группы режима.
local function mode_group(group)
  return MODE_GROUP_PREFIX .. group
end

-- Возвращает атрибуты группы (таблицу) с учётом ссылок (link).
local function get_resolved_hl(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false })
end

-- Возвращает название текущего режима с его подсветкой.
-- Вызывать через '%{%v:lua.StatusLine.mode_block()%}'.
function StatusLine.mode_block()
  local mode = vim.fn.mode()
  local info = MODES[mode:sub(1, 1)] or MODES.other
  local label = info.label or mode

  return string.format('%%#%s# %s %%*', mode_group(info.group), label)
end

-- Возвращает имена LSP-клиентов текущего буфера.
-- Вызывать через '%{v:lua.StatusLine.lsp_clients()}'.
function StatusLine.lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  -- if #clients == 0 then
  --   return 'n/a'
  -- end

  return table.concat(
    vim.tbl_map(function(client)
      return client.name
    end, clients),
    ', ' -- │
  )
end

-- Создаёт highlight-группы. Текст подбирается под цвета текущей темы.
local function update_highlights()
  local normal_hl = get_resolved_hl('Normal')
  local default_fg = normal_hl.fg or 0xFFFFFF
  local default_bg = normal_hl.bg or 0x000000

  -- Заливает блок цветом `background`, текст подбирается по контрасту.
  -- Без цвета очищает группу, чтобы не остались цвета предыдущей темы.
  local function set_block_hl(group, background, base_hl)
    if not background then
      vim.api.nvim_set_hl(0, group, {})
      return
    end

    vim.api.nvim_set_hl(
      0,
      group,
      vim.tbl_extend('force', base_hl or {}, {
        fg = color_utils.get_more_contrast(background, default_fg, default_bg),
        bg = background,
        bold = true,
      })
    )
  end

  -- Несколько режимов могут делить одну группу (например, Visual).
  local done = {}

  for _, info in pairs(MODES) do
    if not done[info.group] then
      set_block_hl(mode_group(info.group), COLORS[info.color])
      done[info.group] = true
    end
  end

  local pmenu_sel_hl = get_resolved_hl('PmenuSel')
  set_block_hl(LOCATION_GROUP, pmenu_sel_hl.bg, pmenu_sel_hl)
end

-- Повторно создаём группы при смене цветовой схемы.
vim.api.nvim_clear_autocmds({
  group = augroup,
  event = 'ColorScheme',
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
  ' %#' .. LOCATION_GROUP .. '# %3l:%-2v │ %3p%% %*',
})
