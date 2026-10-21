local MODES = {
  n = { label = 'NORMAL', group = 'Function' },
  i = { label = 'INSERT', group = 'String' },
  v = { label = 'VISUAL', group = 'Keyword' },
  V = { label = 'V-LINE', group = 'Keyword' },
  ['\22'] = { label = 'V-BLOCK', group = 'Keyword' },
  c = { label = 'COMMAND', group = 'Constant' },
  R = { label = 'REPLACE', group = 'DiagnosticError' },
  t = { label = 'TERMINAL', group = 'Type' },
  -- Для режимов, которых нет в таблице (select, prompt и т.д.)
  other = { group = 'Type' },
}

StatusLine = {}

-- Блок режима: подсветка зависит от режима, поэтому группа выбирается при
-- каждой отрисовке. Возвращает кусок строки статуса, а не просто текст,
-- поэтому вызывать нужно через '%{%...%}'
function StatusLine.mode_block()
  local mode = vim.fn.mode()
  -- Первый символ: 'no' (operator-pending) считается как 'n'
  local entry = MODES[mode:sub(1, 1)] or MODES.other

  -- %* возвращает подсветку по умолчанию (StatusLine / StatusLineNC)
  return string.format(
    '%%#StatusLineMode%s# %-8s %%*',
    entry.group,
    entry.label or mode
  )
end

function StatusLine.lsp_client_names()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = client.name
  end
  return table.concat(names, ', ')
end

local function get_highlight(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false })
end

-- Относительная яркость цвета 0xRRGGBB по WCAG: от 0 (чёрный) до 1 (белый)
local function get_luminance(color)
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
local function get_contrast(color_a, color_b)
  local luminance_a = get_luminance(color_a)
  local luminance_b = get_luminance(color_b)

  local lighter = math.max(luminance_a, luminance_b)
  local darker = math.min(luminance_a, luminance_b)

  return (lighter + 0.05) / (darker + 0.05)
end

-- Из fg и bg темы (Normal) выбирает цвет текста, лучше читаемый на фоне
-- background. Так текст остаётся читаемым и в тёмных, и в светлых темах
local function get_readable_color(background, normal)
  -- Если у Normal цвета не заданы (прозрачная тема), считаем по умолчанию
  local dark = normal.bg or 0x000000
  local light = normal.fg or 0xffffff

  if get_contrast(dark, background) >= get_contrast(light, background) then
    return dark
  end

  return light
end

local function setup_mode_highlights()
  local normal = get_highlight('Normal')

  -- Режим: акцентный цвет берётся из цвета текста группы (у групп вроде
  -- Function он всегда задан и хорошо виден), жирным (ссылкой bold не добавить).
  -- Группа может повторяться у разных режимов, тогда она просто
  -- переопределяется тем же значением
  for _, mode in pairs(MODES) do
    local accent = get_highlight(mode.group).fg

    vim.api.nvim_set_hl(0, 'StatusLineMode' .. mode.group, {
      fg = accent and get_readable_color(accent, normal) or normal.fg,
      bg = accent,
      bold = true,
    })
  end
end

-- Подсветка зависит от цветов темы, поэтому считать её можно только после
-- применения темы: сразу после вызова vim.cmd.colorscheme, а она у меня в
-- VimEnter вызывается...
--
-- Кроме того, :colorscheme сбрасывает все highlight-группы (в том числе
-- пользовательские), так что группы нужно создавать заново при каждой смене
-- темы. Событие ColorScheme срабатывает после каждого применения темы.
--
-- То же самое при автоматической загрузке плагинов
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_mode_highlights,
})

-- Доступен только вызов глобальных функций
-- '%{v:lua.foo()}' возвращает строку как есть
-- '%{%v:lua.foo()%}' дополнительный разбирает выражения, возвращаемые ей
vim.opt.statusline = table.concat({
  -- Левая часть
  '%{%v:lua.StatusLine.mode_block()%}',
  ' %<%t%m%r', -- %t - имя файла, %f - отн путь
  ' %{%v:lua.vim.ui.progress_status()%}',

  '%=',

  -- Правая часть
  '%k',
  ' %{%v:lua.vim.diagnostic.status()%}',
  ' %{v:lua.StatusLine.lsp_client_names()}',
  ' %3l:%-2v',
})
