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
    filesystem = {
      filtered_items = {
        close_if_last_window = true,
        hide_by_name = {
          -- add extension names you want to explicitly exclude
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {},
        show_hidden_count = true,
        visible = true,
      },
    },
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          -- auto close
          -- vim.cmd("Neotree close")
          -- OR
          -- require("neo-tree.command").execute({ action = "close" })
        end
      },
    },
  },
}
