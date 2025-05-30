-- tree-sitter является зависимостью Neovim и используется для парсинга
-- исходников в AST для навигации по коду, лучшей подсветки синтаксиса,
-- например, в Vue-компонентах (HTML + JS + CSS), а так же применяется тем же
-- DAP. Без него подсветка синтаксиса будет работать благодаря файлам синтаксиса
-- vim, но вот остальное...
return {
  -- Этот плагин содержит настройки
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main", -- master заморожен
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      -- В арче tree-sitter-lua - это зависимость neovim, т.е. lua ставить не надо
      -- :TSInstall python
      -- Можно предустановить парсеры для treesitter
      ensure_installed = {
        "go",
        "javascript",
        "php",
        "python",
        "typescript",
      },
      sync_install = false,
      -- Но если включена автоматическая установка, никакие парсеры прописывать
      -- не надо
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
