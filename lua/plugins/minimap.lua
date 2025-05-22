return {
  "gorbit99/codewindow.nvim",
  opts = {
    auto_enable = true
  },
  config = function(_, opts)
    local codewindow = require('codewindow')
    codewindow.setup(opts)
    codewindow.apply_default_keybinds()
  end,
}
