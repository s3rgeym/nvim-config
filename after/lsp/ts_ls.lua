-- Настройки для совместной работы с vue_ls, который текущий сервер использует
-- для разбора секции scripr в компонетах vue
return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = '/usr/lib/node_modules/@vue/language-server',
        languages = { 'vue' },
        configNamespace = 'typescript',
      },
    },
  },
}
