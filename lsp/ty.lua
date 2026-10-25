-- В nvim-lspconfig его нет
-- https://docs.astral.sh/ty/reference/editor-settings/
return {
  settings = {
    ty = {
      -- По умолчанию диагностика только для открытых файлов.
      -- 'workspace' проверяет весь проект.
      diagnosticMode = 'workspace',

      inlayHints = {
        variableTypes = false,
      },

      -- Отдельный файл конфигурации вместо ty.toml / pyproject.toml
      -- configurationFile = './.config/ty.toml',

      experimental = {
        rename = true,
      },
    },
  },
}
