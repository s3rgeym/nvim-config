return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "FzfLua", -- fix: Not and editor command: FzfLua ... при использовании в keys
  config = function()
    require('fzf-lua').setup()
    require('fzf-lua').register_ui_select()
  end,
}
