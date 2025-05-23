return {
  "gorbit99/codewindow.nvim",
  config = function(_, opts)
    local codewindow = require('codewindow')
    codewindow.setup({
      auto_enable = false,
    })
    codewindow.apply_default_keybinds()
  end,
}
