return {
  settings = {
    basedpyright = {
      analysis = {
        -- Режим проверки типов: "off", "basic" или "strict".
        -- "basic" - базовый уровень проверки типов.
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        -- Режим диагностики: "workspace" - проверяет все файлы в рабочей области,
        -- в отличие от "openFilesOnly", который проверяет только открытые файлы.
        diagnosticMode = 'workspace',
        -- Настройки встроенных подсказок (inlay hints) в редакторе.
        inlayHints = {
          variableTypes = false,
          functionReturnTypes = true,
          callArgumentNames = true,
          genericTypes = false,
        },
      },
    },
  },
}
