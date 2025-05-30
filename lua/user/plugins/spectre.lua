-- Панель для поиска и замены текста

return {
  "windwp/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>S",
      '<cmd>lua require("spectre").toggle()<CR>',
      desc = "Toggle Spectre"
    },
    {
      "<leader>sw",
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      desc = "Search current word",
      mode = "n"
    },
    {
      "<leader>sw",
      '<esc><cmd>lua require("spectre").open_visual()<CR>',
      desc = "Search selected text",
      mode = "v"
    },
    {
      "<leader>sp",
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      desc = "Search in current file"
    },
  },
  config = function()
    require("spectre").setup()
  end,
}
