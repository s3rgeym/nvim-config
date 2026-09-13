vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })

require('ibl').setup({
  indent = { char = '▏' },
  scope = {
    enabled = true,
  },
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
      'oil',
    },
  },
})
