local color_utils = require('utils.color')

local MODE_HL_PREFIX = 'StatusLineMode'

-- vim.g.terminal_color_N не все темы устанавливают (cattpuccin не ставит), а
-- highlight groups типа Function не всегда зеленые
-- Поэтому цвета жестко заданы
-- Название цвета -> hex. Не зависит от темы.
local MODE_COLORS = {
  blue = 0x61AFEF,
  green = 0x98C379,
  purple = 0xC678DD,
  yellow = 0xE5C07B,
  red = 0xE06C75,
  gray = 0x7F848E,
}

-- Результат vim.fn.mode() -> название режима, цвет из MODE_COLORS
-- и суффикс highlight-группы (без префикса).
local MODE_INFO = {
  n = { label = 'NORMAL', color = 'blue', group = 'Normal' },
  i = { label = 'INSERT', color = 'green', group = 'Insert' },
  v = { label = 'VISUAL', color = 'purple', group = 'Visual' },
  V = { label = 'V-LINE', color = 'purple', group = 'Visual' },
  ['\22'] = { label = 'V-BLOCK', color = 'purple', group = 'Visual' },
  c = { label = 'COMMAND', color = 'yellow', group = 'Command' },
  R = { label = 'REPLACE', color = 'red', group = 'Replace' },
  t = { label = 'TERMINAL', color = 'gray', group = 'Other' },
  other = { color = 'gray', group = 'Other' },
}

local statusline_augroup =
  vim.api.nvim_create_augroup('StatusLineHighlights', {})

-- Глобальная: нужна для вызова через v:lua в 'statusline'.
StatusLine = {}

-- Возвращает полное имя highlight-группы режима.
local function get_mode_hl_group(group)
  return MODE_HL_PREFIX .. group
end

-- Возвращает атрибуты группы (таблицу) с учётом ссылок (link).
local function get_hl_attributes(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false })
end

-- Возвращает название текущего режима с его подсветкой.
-- Вызывать через '%{%v:lua.StatusLine.mode_block()%}'.
function StatusLine.mode_block()
  local mode = vim.fn.mode()
  local info = MODE_INFO[mode:sub(1, 1)] or MODE_INFO.other
  local label = info.label or mode

  return string.format('%%#%s# %s %%*', get_mode_hl_group(info.group), label)
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
    ', '
  )
end

-- Создаёт highlight-группы. Текст подбирается под цвета текущей темы.
local function update_highlights()
  local normal_hl = get_hl_attributes('Normal')
  local default_fg = normal_hl.fg or 0xFFFFFF
  local default_bg = normal_hl.bg or 0x000000

  -- Заливает блок цветом `background`, текст подбирается по контрасту.
  -- Без цвета очищает группу, чтобы не остались цвета предыдущей темы.
  local function set_mode_hl(group, background)
    if not background then
      vim.api.nvim_set_hl(0, group, {})
      return
    end

    vim.api.nvim_set_hl(0, group, {
      fg = color_utils.get_more_contrast(background, default_fg, default_bg),
      bg = background,
      bold = true,
    })
  end

  -- Несколько режимов могут делить одну группу (например, Visual).
  local done = {}

  for _, info in pairs(MODE_INFO) do
    if not done[info.group] then
      set_mode_hl(get_mode_hl_group(info.group), MODE_COLORS[info.color])
      done[info.group] = true
    end
  end
end

-- Повторно создаём группы при смене цветовой схемы.
vim.api.nvim_clear_autocmds({
  group = statusline_augroup,
  event = 'ColorScheme',
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = statusline_augroup,
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
  ' %3l:%-2v ',
})
