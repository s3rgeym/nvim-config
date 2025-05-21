-- Файловый менеджер
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view = { width = 30 },
    filters = { dotfiles = false },
    git = { enable = true },
    actions = {
      open_file = {
        quit_on_open = true, -- закроет дерево после открытия файла
      },
    },
    hijack_netrw = true, -- авто-закрытие при последнем буфере
  },
  keys = {
    { "<C-p>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle files panel", mode = "n" },
  },
}
