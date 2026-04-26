vim.cmd('packadd nvim.undotree')

require('utils').map('<leader>u', function()
  require('undotree').open()
end, 'Undotree')
