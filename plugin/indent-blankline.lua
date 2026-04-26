vim.pack.add(
  { 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { confirm = false }
)

require('ibl').setup({
  indent = { char = '▏' },
  exclude = {
    filetypes = {
      'help',
      'terminal',
      'lazy',
      'lspinfo',
      'mason',
      'Neotree',
      'packer',
      'checkhealth',
      'Trouble',
      'DressingInput',
      'DressingSelect',
      'oil', -- oil.nvim
    },
  },
})
