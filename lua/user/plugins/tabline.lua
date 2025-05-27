return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      separator_style = "slant",
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "neo-tree",
          text = "Nvim Tree",
          separator = true,
          text_align = "left",
        },
      },
    }
  },
}
