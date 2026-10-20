return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        -- Режим проверки типов: "off", "basic" или "strict".
        -- "basic" - базовый уровень проверки типов.
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        -- Режим диагностики: "workspace" проверяет все файлы
        -- в рабочей области, в отличие от "openFilesOnly",
        -- который проверяет только открытые файлы.
        diagnosticMode = 'workspace',
        diagnosticSeverityOverrides = {
          reportUnusedImport = 'none',
          reportUnusedVariable = 'none',
          reportUnusedClass = 'none',
          reportUnusedFunction = 'none',
        },
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
