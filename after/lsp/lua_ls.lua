return {
  settings = {
    Lua = {
      runtime = {
        -- Указывает версию среды выполнения Lua.
        -- 'LuaJIT' - для использования LuaJIT.
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Глобальные переменные, которые должны быть распознаны
        -- и не вызывать ошибок "undeclared global".
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        -- Указывает путь к библиотекам Lua для лучшей проверки типов и автодополнения.
        -- vim.api.nvim_get_runtime_file("", true) возвращает путь к стандартным файлам runtime Neovim.
        library = vim.api.nvim_get_runtime_file("", true),
      },
      format = {
        enable = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
