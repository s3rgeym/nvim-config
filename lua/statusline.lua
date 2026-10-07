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

function custom_mode()
  return mode_names[vim.fn.mode()] or vim.fn.mode()
end

function git_status()
  status = vim.b.gitsigns_status_dict

  if not status then
    return ''
  end

  -- \u{f418}
  result = '\u{e725} ' .. status.head

  if (status.added or 0) > 0 then
    result = result .. ' +' .. status.added
  end

  if (status.changed or 0) > 0 then
    result = result .. ' ~' .. status.changed
  end

  if (status.removed or 0) > 0 then
    result = result .. ' -' .. status.removed
  end

  return result
end

function lsp_clients()
  return table.concat(
    vim.tbl_map(function(client)
      return client.name
    end, vim.lsp.get_clients({ bufnr = 0 })),
    ' │ '
  )
end

function diagnostic_status()
  local errors =
    #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings =
    #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local result = {}

  if errors > 0 then
    table.insert(result, 'E:' .. errors)
  end

  if warnings > 0 then
    table.insert(result, 'W:' .. warnings)
  end

  return table.concat(result, ' ')
end

local get_hl = function(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function setup_statusline_hl()
  -- Чтобы узнать highlight группу токена можно использовать :Inspect
  local normal_hl = get_hl('Normal')
  local accent_hl = get_hl('Function')

  vim.api.nvim_set_hl(0, 'StatusLineAccent', {
    fg = normal_hl.bg,
    bg = accent_hl.fg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, 'StatusLineLeftSep', {
    fg = accent_hl.fg,
    bg = 'NONE',
  })

  vim.api.nvim_set_hl(0, 'StatusLineRightSep', {
    fg = accent_hl.fg,
    bg = 'NONE',
  })
end

-- Узнать цвета подсветок можно только после применения темы: сразу после вызова
-- vim.cmd.colorscheme, а она у меня в VimEnter вызывается...

-- То же самое при автоматической загрузке плагинов
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_statusline_hl,
})

-- Доступен только вызов глобальных функций
-- '%{v:lua.foo()}' возвращает строку как есть
-- '%{%v:lua.foo()%}' дополнительное разбирает выражения, возвращаемые ей
vim.opt.statusline = table.concat({
  '%#StatusLineAccent# %-8.8{v:lua.custom_mode()}%#StatusLineLeftSep#\u{e0b0}',
  '%#StatusLine# %<%f%m%r ',
  ' %{v:lua.git_status()} ',
  ' %{%v:lua.vim.ui.progress_status()%} ',
  '%=',
  ' %k ',
  ' %{%v:lua.vim.diagnostic.status()%} ',
  ' %{v:lua.lsp_clients()} ',
  '%#StatusLineRightSep#\u{e0b2}%#StatusLineAccent# %3l:%-2v ',
}, '')
