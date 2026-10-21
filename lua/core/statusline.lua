local color_utils = require('utils.color')

local mode_names = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  c = 'COMMAND',
  R = 'REPLACE',
  t = 'TERMINAL',
}

function statusline_mode()
  return mode_names[vim.fn.mode()] or vim.fn.mode()
end

function statusline_lsp_clients()
  local lsp_names = vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients({ bufnr = 0 }))
  -- То же не очень смотрится, когда отсутствует диагностика
  -- table.insert(lsp_names, 1, '')
  return table.concat(
    lsp_names,
    ' \u{e0b3} '
    -- ' │ '
  )
end

local get_hl = function(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function setup_statusline_hl()
  -- Чтобы узнать highlight группу токена можно использовать :Inspect
  local normal_hl = get_hl('Normal')
  local edge_hl = get_hl('Function') -- цвет крайних блоков
  local inner_hl = get_hl('String') -- цвет внутренних блоков
  -- Можно просто задать цвет фона
  -- local edge_fg = normal_hl.bg
  -- Но лучше определять более контратный цвеь
  local edge_fg =
    color_utils.pick_contrasting(edge_hl.fg, normal_hl.fg, normal_hl.bg)
  local inner_fg =
    color_utils.pick_contrasting(inner_hl.fg, normal_hl.fg, normal_hl.bg)

  -- Крайние блоки (слева и справа)
  local edge_style = { fg = edge_fg, bg = edge_hl.fg }

  vim.api.nvim_set_hl(0, 'StatusLineEdge', edge_style)
  vim.api.nvim_set_hl(
    0,
    'StatusLineMode',
    vim.tbl_extend('force', edge_style, { bold = true })
  )

  -- Слева: стрелка из крайнего блока во внутренний
  vim.api.nvim_set_hl(0, 'StatusLineLeftArrowEdge', {
    fg = edge_hl.fg,
    bg = inner_hl.fg,
  })

  -- Внутренние блоки (слева и справа)
  vim.api.nvim_set_hl(0, 'StatusLineInner', {
    fg = inner_fg,
    bg = inner_hl.fg,
  })

  -- Слева: стрелка из внутреннего блока в обычную строку
  vim.api.nvim_set_hl(0, 'StatusLineLeftArrowInner', {
    fg = inner_hl.fg,
    bg = 'NONE',
  })

  -- Справа: стрелка из обычной строки во внутренний блок
  vim.api.nvim_set_hl(0, 'StatusLineRightArrowInner', {
    fg = inner_hl.fg,
    bg = 'NONE',
  })

  -- Справа: стрелка из внутреннего блока в крайний
  vim.api.nvim_set_hl(0, 'StatusLineRightArrowEdge', {
    fg = edge_hl.fg,
    bg = inner_hl.fg,
  })
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
  callback = setup_statusline_hl,
})

-- Доступен только вызов глобальных функций
-- '%{v:lua.foo()}' возвращает строку как есть
-- '%{%v:lua.foo()%}' дополнительное разбирает выражения, возвращаемые ей
vim.opt.statusline = table.concat({
  '%#StatusLineMode# %-8.8{v:lua.statusline_mode()} %#StatusLineLeftArrowEdge#\u{e0b0}',
  '%#StatusLineInner# %<%t%m%r %#StatusLineLeftArrowInner#\u{e0b0}', -- %t - имя файла, %f - отн путь
  '%#StatusLine# %{%v:lua.vim.ui.progress_status()%} ',
  '%=',
  ' %k ',
  ' %{%v:lua.vim.diagnostic.status()%} ',
  ' %{v:lua.statusline_lsp_clients()} ',
  '%#StatusLineRightArrowInner#\u{e0b2}%#StatusLineInner# %{&filetype} ',
  '%#StatusLineRightArrowEdge#\u{e0b2}%#StatusLineEdge# %3l:%-2v ',
}, '')
