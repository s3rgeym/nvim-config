local M = {}

function M.ReloadConfig()
  for pkg, _ in pairs(package.loaded) do
    -- user.plugins.* грузятся lazy.nvim динамически, поэтому их исключаем
    if pkg:match("^user") and not pkg:match("^user[%./]plugins") then
      package.loaded[pkg] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

return M
