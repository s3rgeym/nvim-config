local M = {}

--- Reloads the Neovim config file based on its extension (.vim or .lua)
function M.reload_config()
  local config = vim.env.MYVIMRC
  if not config or config == '' then
    vim.notify('MYVIMRC is not set', vim.log.levels.ERROR)
    return
  end

  local ok, err
  if config:match('%.vim$') then
    ok, err = pcall(vim.cmd, 'source ' .. config)
  elseif config:match('%.lua$') then
    ok, err = pcall(vim.cmd, 'luafile ' .. config)
  else
    vim.notify('Unsupported config file type: ' .. config, vim.log.levels.ERROR)
    return
  end

  if ok then
    vim.notify('Config reloaded: ' .. config, vim.log.levels.INFO)
  else
    vim.notify('Error reloading config: ' .. err, vim.log.levels.ERROR)
  end
end

return M
