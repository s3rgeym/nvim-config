-- Файловый менеджер
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
  },
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree", mode = "n" },
  },
}
