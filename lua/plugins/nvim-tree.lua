-- Файловый менеджер
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sync_root_with_cwd = true, -- синхронизировать дерево с текущей рабочей директорией (:cd)
    actions = {
      open_file = {
        quit_on_open = true, -- закроет дерево после открытия файла
      },
    },
  },
  keys = {
    { "<C-p>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle files panel", mode = "n" },
  },
}
