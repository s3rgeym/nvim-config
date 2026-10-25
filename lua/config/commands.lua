-- Управление поагинами
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

vim.api.nvim_create_user_command('PackClean', function()
  vim.pack.del(vim
    .iter(vim.pack.get())
    :filter(function(plugin)
      return not plugin.active
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable())
end, {})
