# Neovim Config

## Описание

![Screenshot_20250523_005638](https://gist.github.com/user-attachments/assets/e24e9bd9-d2c5-4fca-a94d-8809a6ff9a92)

Конфиг с настроенным LSP и дебаггером. Vim я не пользуюсь больше и другим не советую из-за политической позиции его разработчиков.

![Fuck you Vim.org](https://i.imgur.com/kBFTJlg.jpeg)

> Fuck u, vim org!

* Конфиг разбит на файлы, которые находятся в директории `lua/`.
* `configs/settings.lua` содержит общие настройки.
* Сочетания клавиш находятся в `configs/keymaps.lua`.
* Клавиша `leader` — `Space`.
* `Ctrl-6` служит для переключения раскладки из Vim, при этом сочетания будут работать (при переключении системной — лишь некоторые).
* `F2` — для включения spell check.
* Автодополнение вызывается по `Ctrl-Space` либо `Ctrl-S`, выбор вариантов табом. `K` в нормальном режиме покажет справку, ее можно прокручивать мышью, либо нажав еще раз `K`
или `<c-w>w`, тогда иожно будет прокручивать всплывающее окна с `Ctrl-f/Ctrl-b`.
Возможно, стоит добавить сочетание для этого... не знаю.
* Если ввести `g`, то `which-key` покажет все доступные сочетания с `g` в всплывающем окне.
* Настроен для работы с `Python`.
* Языковые сервера и пр нужно прописывать в `plugins/lsp.lua`. 
* `plugins/dap.lua` — дебаггер. F9 добавляет breakpoint, F5 — запускает отладку.
  Поддерживаются `.vscode/launch.json`.
* Добавлен `.luarc.json` для включения автодополнения lua-конфигов nvim ([отсюда](https://lsp-zero.netlify.app/docs/guide/neovim-lua-ls.html)).
* Используй `Ctrl-]` для того чтобы найти `help` для слова под курсором.
* Встроенный терминал нужно закрывать с `:q!`.

## Установка и зависимости

```sh
sudo pacman -S neovim
```

Для копирования текста в буфер обмена нужны xclip (сессия X) или wl-copy (Wayland):

```sh
sudo pacman -S wl-clipboard xclip
```

Для поиска текста по регулярному выражению:

```sh
sudo pacman -S ripgrep
```

Так же нужен патченный nerd-шрифт, например:

```sh
sudo pacman -S ttf-jetbrains-mono-nerd
```

Зависимости python:

```sh
sudo pacman -S pyright ruff python-debugpy
```

## Добавление поддержки других языков

* В `plugins/lsp.lua` добавить языковой сервер.
* В `plugins/dap.lua` добавить настройки дебаггера для языка X.
* В `plugins/tree-sitter.lua` добавить язык, так как lsp и dap используют языковые парсеры для определенного функционала.

## Использование lazy.nvim

`lazy.nvim` по умолчанию грузит модули асинхронно. Вот небольшая справка по его использованию:

```lua
-- Основной вызов Lazy.nvim
require("lazy").setup(opts)

-- Где opts — это таблица (массив) с описаниями плагинов.
-- Каждый элемент таблицы описывает один плагин.

{
  -- Указывается репозиторий плагина на GitHub
  "github_user/repo",

  -- Настройка плагина: вызывается при его загрузке
  -- Можно использовать для ручной инициализации, настройки событий и т.д.
  -- В opts содержится значение соответствующего ключа
  config = function(_, opts)
    local plugin = require("plugin_name")
    plugin.setup({
      option1 = true,
      option2 = "value",
    })
  end,

  -- Альтернатива config: если плагин поддерживает setup(opts),
  -- можно указать опции напрямую, и lazy.nvim сам вызовет setup(opts)
  opts = {
    option1 = true,
    option2 = "value",
  },

  -- Если устраивают настройки по умолчанию
  -- (и setup вызывается без параметров), можно передать пустую таблицу
  opts = {},

  -- Или можно просто указать config = true, если плагин сам настроится при require
  config = true,

  -- Необязательное поле: зависимости (будут установлены автоматически)
  dependencies = {
    "github-user/dependency1",
    -- В зависимости так же можно передавать opts для автоматического вызова setup
    { "github-user/dependency2", opts = {} },
    -- и т.д.
  },

  -- Указывает, загружать ли плагин по требованию (true по умолчанию).
  -- Устанавливаем lazy = false, если плагин должен быть загружен сразу (например, тема или ключи)
  lazy = false,

  -- Определение горячих клавиш
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Поиск файлов" },
    { "<C-s>", ":w<CR>", desc = "Сохранить файл", mode = "n" },
    -- mode по умолчанию = "n", можно задать "i", "v", "n", "t" и т.п.
  },

  -- Можно указать команду или событие, при котором плагин будет загружен:
  cmd = { "SomeCommand" },
  event = { "BufReadPost", "BufNewFile" },

  -- Так же плагин может загружаться только для определенных типов файлов
  ft = "python",
}

-- Альтернатива: можно передать путь к модулю, экспортирующему список плагинов
require("lazy").setup("path.to.plugins")

-- Где path/to/plugins.lua может выглядеть как:
return {
  {
    "github-user/foo",
    opts = {},
  },
  {
    "github-user/bar",
    config = function()
      require("bar").setup()
    end,
  },
}

-- Или если в каталоге `lua/path/to/plugins/` несколько файлов:
-- каждый файл экспортирует таблицу(ы) с описанием плагинов:
-- plugins/foo.lua:
return {
  "github-user/foo",
  opts = {},
}

-- plugins/bar.lua:
return {
  "github-user/bar",
  config = true,
}

-- Ошибка: модуль не найден
local foo = require("foo")
require("lazy").setup({ ... })

-- Так же приведет к ошибке, так как модуль ленивый
require("lazy").setup({
  {
    "github-user/foo",
    lazy = true, -- это значение по умолчанию
  },
})

local foo = require("foo")

-- Таким образом, самый надежный вариант
{
  "github-user/foo",
  -- зависимости тоже гарантированно доступны для загрузки
  dependencies = "github-user/bar",
  config = function()
    local foo = require("foo")
    foo.setup {}
    local bar = require("bar")
    bar.setup()
  end,
}
```

## Прочее

Удаление плагинов, кеша и тп:

```sh
rm -rf ~/.local/share/nvim
```
