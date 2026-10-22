-- label    - текст в строке статуса
-- hl_group - имя highlight-группы, которой красится плашка с названием режима
-- color    - индекс ANSI-цвета в vim.g.terminal_color_N, он станет фоном группы:
--            1 красный, 2 зелёный, 3 жёлтый, 4 синий, 5 пурпурный, 6 циан,
--            8 ярко-чёрный
-- Если тема этот цвет не задаёт, группа не создаётся и плашка не красится
local MODES = {
  n = { label = 'NORMAL', hl_group = 'StatusLineModeNormal', color = 4 },
  i = { label = 'INSERT', hl_group = 'StatusLineModeInsert', color = 2 },
  v = { label = 'VISUAL', hl_group = 'StatusLineModeVisual', color = 5 },
  V = { label = 'V-LINE', hl_group = 'StatusLineModeVisual', color = 5 },
  ['\22'] = { label = 'V-BLOCK', hl_group = 'StatusLineModeVisual', color = 5 },
  c = { label = 'COMMAND', hl_group = 'StatusLineModeCommand', color = 3 },
  R = { label = 'REPLACE', hl_group = 'StatusLineModeReplace', color = 1 },
  t = { label = 'TERMINAL', hl_group = 'StatusLineModeTerminal', color = 6 },
  -- Для режимов, которых нет в таблице (select, prompt и т.д.)
  other = { hl_group = 'StatusLineModeOther', color = 8 },
}

-- Группы, которые удалось создать для текущей темы: { [имя группы] = true }.
-- Заполняется в update_highlights()
local active_hl_groups = {}

StatusLine = {}

-- Название режима: подсветка зависит от режима, поэтому группа выбирается при
-- каждой отрисовке. Возвращает кусок строки статуса, а не просто текст,
-- поэтому вызывать нужно через '%{%...%}'
function StatusLine.mode_name()
  local mode = vim.fn.mode()
  -- Первый символ: 'no' (operator-pending) считается как 'n'
  local entry = MODES[mode:sub(1, 1)] or MODES.other
  local label = entry.label or mode

  if not active_hl_groups[entry.hl_group] then
    return string.format(' %s ', label)
  end

  -- %* возвращает подсветку по умолчанию (StatusLine / StatusLineNC)
  return string.format('%%#%s# %s %%*', entry.hl_group, label)
end

function StatusLine.lsp_client_names()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = client.name
  end
  return table.concat(names, ', ')
end

-- Относительная яркость цвета 0xRRGGBB по WCAG: от 0 (чёрный) до 1 (белый)
local function luminance(color)
  local function linearize(channel)
    channel = channel / 255
    if channel <= 0.03928 then
      return channel / 12.92
    end
    return ((channel + 0.055) / 1.055) ^ 2.4
  end

  local red = linearize(bit.rshift(color, 16) % 256)
  local green = linearize(bit.rshift(color, 8) % 256)
  local blue = linearize(color % 256)

  return 0.2126 * red + 0.7152 * green + 0.0722 * blue
end

-- Контрастность двух цветов по WCAG: от 1 (одинаковые) до 21 (чёрный и белый)
local function contrast(color_a, color_b)
  local luminance_a = luminance(color_a)
  local luminance_b = luminance(color_b)

  local lighter = math.max(luminance_a, luminance_b)
  local darker = math.min(luminance_a, luminance_b)

  return (lighter + 0.05) / (darker + 0.05)
end

-- Из двух цветов выбирает тот, что контрастнее на фоне background
local function get_more_contrast(background, color_a, color_b)
  if contrast(color_a, background) >= contrast(color_b, background) then
    return color_a
  end

  return color_b
end

-- Читает vim.g.terminal_color_<index> и возвращает число 0xRRGGBB.
-- Значение может быть '#rrggbb' или именем цвета.
-- Если переменная не задана или не распознана, возвращает nil
local function terminal_color(index)
  local value = vim.g['terminal_color_' .. index]
  if type(value) ~= 'string' then
    return nil
  end

  local color = vim.api.nvim_get_color_by_name(value)
  if color == -1 then
    return nil
  end

  return color
end

-- Создаёт highlight-группы с цветами из палитры терминала текущей темы
local function update_highlights()
  -- Из StatusLine цвета лучше не брать, так как они могут быть не заданы, так
  -- как используется reverse=true
  local normal_hl = vim.api.nvim_get_hl(0, {
    name = 'Normal',
    link = false,
  })

  local normal_fg = normal_hl.fg or 0xFFFFFF
  local normal_bg = normal_hl.bg or 0x000000

  active_hl_groups = {}

  for _, entry in pairs(MODES) do
    local color = terminal_color(entry.color)

    if color then
      vim.api.nvim_set_hl(0, entry.hl_group, {
        fg = get_more_contrast(color, normal_fg, normal_bg),
        bg = color,
        bold = true,
      })
      active_hl_groups[entry.hl_group] = true
    else
      -- Цвета нет в новой теме: сбрасываем группу от прошлой
      vim.api.nvim_set_hl(0, entry.hl_group, {})
    end
  end
end

-- :colorscheme сбрасывает пользовательские highlight-группы,
-- поэтому создаём их заново при каждой смене темы.
-- Группа нужна, чтобы повторный :source не плодил дубликаты автокоманд
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('StatusLineModes', { clear = true }),
  callback = update_highlights,
})

-- Тема могла быть загружена до этого файла, а ColorScheme тогда не сработает
update_highlights()

-- Доступен только вызов глобальных функций
-- '%{v:lua.foo()}' возвращает строку как есть
-- '%{%v:lua.foo()%}' дополнительно разбирает выражения, возвращаемые ей
vim.opt.statusline = table.concat({
  -- Левая часть
  '%{%v:lua.StatusLine.mode_name()%}',
  ' %<%t%m%r', -- %t - имя файла, %f - отн путь
  ' %{%v:lua.vim.ui.progress_status()%}',

  '%=',

  -- Правая часть
  '%k',
  ' %{%v:lua.vim.diagnostic.status()%}',
  ' %{v:lua.StatusLine.lsp_client_names()}',
  ' %3l:%-2v ',
})
