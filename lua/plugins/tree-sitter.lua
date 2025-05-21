-- tree-sitter используется для парсинга исходников в AST для навигации по коду, лучшей подсветки синтаксиса, например, в Vue-компонентах (HTML + JS + CSS), а так же применяется тем же DAP. Без него подсветка синтаксиса будет работать благодаря файлам синтаксиса vim, но вот остальное...
-- :checkhealth nvim-treesitter (так можно проверить любой плагин)
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      -- Парсеры для каждого языка нужно ставить отдельно
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "csv",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        -- "markdown",
        "lua",
        "php",
        "python",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
