vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
})

-- Тема устанавливается по VimEnter чтобы темы, установленные через плагины,
-- успели загрузиться
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.opt.showmode = false

    require('lualine').setup({
      options = {
        globalstatus = true,
        -- В консоли Linux пустые квадраты вместо иконок
        -- icons_enabled = vim.env.TERM == "linux",
        -- component_separators = { left = '│', right = '│' },
        -- section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
          },
          vim.ui.progress_status,
        },
        lualine_c = { { 'filename', path = 0 } },
        lualine_x = {
          function()
            return vim.opt.iminsert:get() > 0 and vim.b.keymap_name or ''
          end,
          'lsp_status',
          --'encoding',
          --'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      -- Сверху можно буферы и табы отображать, но когда буферов много, они лишь
      -- глаза мозолят, а табы можно отображать встроенными средствами
      -- tabline = {
      --   lualine_a = { { 'buffers', mode = 2 } },
      --   lualine_z = {
      --     {
      --       'tabs',
      --       mode = 2,
      --       cond = function()
      --         return #vim.api.nvim_list_tabpages() > 1
      --       end,
      --     },
      --   },
      -- },
    })
  end,
})
