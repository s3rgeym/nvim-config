-- Debugger (от Debug Adapter Protocol)
local map = require("utils").map

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio", -- nvim-dap-ui requires nvim-nio to be installed. Install from https://github.com/nvim-neotest/nvim-nio
    "theHamsta/nvim-dap-virtual-text",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")

    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup()
    dapui.setup()

    require("mason-nvim-dap").setup({
      ensure_installed = { "python" }, -- автоматически поставит debugpy
      automatic_installation = true,
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    })

    -- Если debugpy установлен, то можно прописать до него путь вместо установкм через mason-nvim-dap
    -- dap.adapters.python = {
    --   type = 'executable',
    --   command = '/path/to/your/python',
    --   args = { '-m', 'debugpy.adapter' },
    -- }

    -- UI авто-открытие/закрытие
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    map("n", "<F5>", dap.continue, "Continue debug")
    map("n", "<F10>", dap.step_over, "Debug: step over")
    map("n", "<F11>", dap.step_into, "Debug: step into")
    map("n", "<F12>", dap.step_out, "Debug: step out")
    map("n", '<M-b>', dap.toggle_breakpoint, "Toggle beakpoint")
    map({ "n", "v" }, '<M-e>', dapui.eval, "Eval expression")
  end,
}
