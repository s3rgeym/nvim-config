vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}, { confirm = false })

local function keymap()
  if vim.opt.iminsert:get() > 0 and vim.b.keymap_name ~= '' then
    return '\u{f11c} ' .. vim.b.keymap_name
  end
  return ''
end

-- Тема устанавливается по VimEnter чтобы темы, установленные через плагины,
-- успели загрузиться
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.opt.showmode = false

    require('lualine').setup({
      options = {
        globalstatus = true,
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
        },
        lualine_c = { { 'filename', path = 0 } },
        lualine_x = {
          keymap,
          'lsp_status',
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {
        lualine_a = { { 'buffers', mode = 2 } },
        lualine_z = {
          {
            'tabs',
            mode = 2,
            cond = function()
              return #vim.api.nvim_list_tabpages() > 1
            end,
          },
        },
      },
    })
  end,
})
