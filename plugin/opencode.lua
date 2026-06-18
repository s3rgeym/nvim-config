vim.pack.add({
  {
    src = "https://github.com/nickjvandyke/opencode.nvim",
    version = vim.version.range("*"), -- Latest stable release
  },
})

---@type opencode.Opts
vim.g.opencode_opts = {
  -- Add custom options here if needed
}

-- Required for `vim.g.opencode_opts.events.reload`
vim.o.autoread = true

-- Keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode…" })

vim.keymap.set({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Select OpenCode…" })

vim.keymap.set({ "n", "x" }, "go", function()
  return require("opencode").operator("@this ")
end, { desc = "Append range to OpenCode", expr = true })

vim.keymap.set("n", "goo", function()
  return require("opencode").operator("@this ") .. "_"
end, { desc = "Append line to OpenCode", expr = true })

vim.keymap.set("n", "<S-C-u>", function()
  require("opencode").command("session.half.page.up")
end, { desc = "Scroll OpenCode up" })

vim.keymap.set("n", "<S-C-d>", function()
  require("opencode").command("session.half.page.down")
end, { desc = "Scroll OpenCode down" })
