# Neovim Config

Конфиг с настроенным LSP

* `lua/configs/options.lua` содержит общие настройки
* `Ctrl-6` — для переключения раскладки из Vim, при этом сочетания будут работать (при переключении системной — лишь некоторые)
* `F2` — для включения spell check
* языковые сервера сревера и пр нужно прописывать в `lua/configs/plugins.lua`
* `.luarc.json` для включения автодополнения lua-конфигов nvim ([отсюда](https://lsp-zero.netlify.app/docs/guide/neovim-lua-ls.html))
