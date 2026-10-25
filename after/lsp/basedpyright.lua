return {
  settings = {
    basedpyright = {
      analysis = {
        -- По умолчанию "recommended".
        -- Возможные значения: "off", "basic", "standard", "strict", "recommended", "all".
        -- typeCheckingMode = 'basic',
        -- По умолчанию "openFilesOnly".
        -- "workspace" проверяет все файлы в рабочей области.
        diagnosticMode = 'workspace',
        inlayHints = {
          -- По умолчанию true
          variableTypes = false,
        },
      },
    },
  },
}
