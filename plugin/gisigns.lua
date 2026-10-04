vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

local gs = require('gitsigns')

gs.setup({
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, { desc = 'Next git hunk' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, { desc = 'Previous git hunk' })

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, {
      desc = 'Stage hunk',
    })
    map('n', '<leader>hr', gs.reset_hunk, {
      desc = 'Reset hunk',
    })

    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Stage selected hunk' })

    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Reset selected hunk' })

    map('n', '<leader>hS', gs.stage_buffer, {
      desc = 'Stage buffer',
    })
    map('n', '<leader>hR', gs.reset_buffer, {
      desc = 'Reset buffer',
    })
    map('n', '<leader>hp', gs.preview_hunk, {
      desc = 'Preview hunk',
    })
    map('n', '<leader>hi', gs.preview_hunk_inline, {
      desc = 'Preview hunk inline',
    })

    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end, { desc = 'Blame current line' })

    map('n', '<leader>hd', gs.diffthis, {
      desc = 'Diff current file',
    })

    map('n', '<leader>hD', function()
      gs.diffthis('~')
    end, { desc = 'Diff against parent commit' })

    map('n', '<leader>hQ', function()
      gs.setqflist('all')
    end, { desc = 'Send all hunks to quickfix' })

    map('n', '<leader>hq', gs.setqflist, {
      desc = 'Send hunks to quickfix',
    })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, {
      desc = 'Toggle line blame',
    })
    map('n', '<leader>tw', gs.toggle_word_diff, {
      desc = 'Toggle word diff',
    })

    -- Text object
    map({ 'o', 'x' }, 'ih', gs.select_hunk, {
      desc = 'Select hunk',
    })
  end,
})
