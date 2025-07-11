-- Debug Adapter Protocol

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      -- require("mason").setup()
      -- :MasonInstall и ищем отладчики по debug
      -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "python",
        },
        handlers = {
          python = function(config)
            -- Mason всегда прописывает себя первым в PATH, поэтому в виртуальном окружении не видит модули
            -- Использовать debugpy из активного виртуального окружения, если доступно
            local venv_python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python")
            if venv_python then
              config.adapters = {
                type = "executable",
                command = venv_python,
                args = { "-m", "debugpy.adapter" },
              }
            end
            require('mason-nvim-dap').default_setup(config)
          end,
        },
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
    end,
  },
  -- Это неправильно?
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
}
