-- tree-sitter является зависимостью Neovim и используется для парсинга
-- исходников в AST для навигации по коду, лучшей подсветки синтаксиса,
-- например, в Vue-компонентах (HTML + JS + CSS), а так же применяется тем же
-- DAP. Без него подсветка синтаксиса будет работать благодаря файлам синтаксиса
-- vim, но вот остальное...
return {
  -- Этот плагин содержит настройки
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      -- В арче tree-sitter-lua - это зависимость neovim, т.е. lua ставить не надо
      -- :TSInstall python
      -- Можно предустановить парсеры для treesitter
      ensure_installed = { "python" },
      sync_install = false,
      -- Но если включена автоматическая установка, никакие парсеры прописывать
      -- не надо
      auto_install = true,
      highlight = {
        enable = true,
        --На больших файлах подсветка зависает
        disable = function(lang, buf)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        -- additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end
}
