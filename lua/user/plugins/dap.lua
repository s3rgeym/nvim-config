-- Debug Adapter Protocol
local map = require('user.utils').map

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      -- require("mason").setup()
      -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua

      require("mason-nvim-dap").setup({
        ensure_installed = { "python" },
        handlers = {},
      })

      -- Поддержка launch.json
      require('dap.ext.vscode').load_launchjs()

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
      map("n", '<F9>', dap.toggle_breakpoint, "Toggle beakpoint")
      map("n", "<F10>", dap.step_over, "Step over")
      map("n", "<F11>", dap.step_into, "Step into")
      map("n", "<F12>", dap.step_out, "Step out")
      map({ "n", "v" }, '<M-e>', dapui.eval, "Eval expression")
    end,
  },
  -- Автоматическая настройка отладчика для python
  -- sudo pacman -S python-debugpy
  -- {
  --   "mfussenegger/nvim-dap-python",
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   ft = "python", -- Вызываем только для файлов в формате python
  --   config = function()
  --     -- Из-за некродистров с их python3 вместо просто python нужно явно
  --     -- указывать executable (с виртуальными окружениями должно работать)
  --     require('dap-python').setup("python")
  --   end
  -- },
}
