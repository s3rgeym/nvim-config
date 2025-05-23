local M = {}

-- https://www.reddit.com/r/neovim/comments/puuskh/how_to_reload_my_lua_config_while_using_neovim/
function M.reload_nvim_config()
  for name, _ in pairs(package.loaded) do
    if name:match('^user') then
      package.loaded[name] = nil
    end
  end
  -- lazy.nvim имеет какие-то проблемы с живой перезагрузкой
  -- vim.cmd("luafile " .. vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

return M
