local M = {}

-- Объединяет части строки, игнорируя пустые
function M.join_non_empty(parts, sep)
  return vim
    .iter(parts)
    :filter(function(part)
      return part ~= ''
    end)
    :join(sep)
end

return M
