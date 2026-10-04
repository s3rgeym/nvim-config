local function mode()
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

local function git_status()
  local status = vim.b.gitsigns_status_dict

  if not status then
    return ''
  end

  local result = ' ' .. status.head

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

local function lsp_status()
  return table.concat(
    vim.tbl_map(function(client)
      return client.name
    end, vim.lsp.get_clients({ bufnr = 0 })),
    ', '
  )
end

function status_line()
  return table.concat({
    string.format(' %-8s', mode()),
    ' %<%f%m%r',
    ' ' .. git_status(),
    ' %{%v:lua.vim.ui.progress_status()%}',
    '%=',
    ' %k',
    ' %{%v:lua.vim.diagnostic.status()%}',
    ' ' .. lsp_status(),
    ' %14(%l:%c%) ',
  }, '')
end

vim.opt.statusline = '%!v:lua.status_line()'
