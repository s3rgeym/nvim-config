function custom_mode()
  return ({
    n = 'NORMAL',
    i = 'INSERT',
    v = 'VISUAL',
    V = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    c = 'COMMAND',
    R = 'REPLACE',
    t = 'TERMINAL',
  })[vim.fn.mode()] or vim.fn.mode()
end

function git_status()
  status = vim.b.gitsigns_status_dict

  if not status then
    return ''
  end

  result = ' ' .. status.head

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

-- Доступен только вызов глобальных функций
-- '%{v:lua.foo()}' возвращает строку как есть
-- '%{%v:lua.foo()%}' дополнительное разбирает выражения, возвращаемые ей
vim.opt.statusline = table.concat({
  ' %-8.8{v:lua.custom_mode()}',
  ' %<%f%m%r',
  ' %{v:lua.git_status()}',
  ' %{%v:lua.vim.ui.progress_status()%}',
  '%=',
  ' %k',
  ' %{%v:lua.vim.diagnostic.status()%}',
  ' %{v:lua.lsp_clients()}',
  ' %14(%l:%c%) ',
}, '')
