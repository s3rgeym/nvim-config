# Neovim Config

## Описание

Конфиг с настроенным LSP и дебаггером. Vim я не пользуюсь больше и другим не советую из-за политической позиции его разработчиков.

![Fuck you Vim.org](https://i.imgur.com/kBFTJlg.jpeg)

* Конфиг разбит на файлы, которые находятся в директории `lua/`.
* `settings.lua` содержит общие настройки.
* Сочетания клавиш находятся в `keymaps.lua`.
* Клавиша `leader` — это `Space`.
* `Ctrl-6` служит для переключения раскладки из Vim, при этом сочетания будут работать (при переключении системной — лишь некоторые).
* `F2` — для включения spell check.
* Автодополнение вызывается по `Ctrl-Space` либо `Ctrl-S`, выбор вариантов табом.
* Если ввести `g`, то `which-key` покажет все доступные сочетания в всплывающем окне.
* Языковые сервера и пр нужно прописывать в `plugins/lsp.lua`.
* `plugins/dap.lua` — дебаггер.
* Добавлен `.luarc.json` для включения автодополнения lua-конфигов nvim ([отсюда](https://lsp-zero.netlify.app/docs/guide/neovim-lua-ls.html)).

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

## Заметки

### Использование lazy.nvim

`lazy.nvim` по умолчанию грузит модули асинхронно. Вот небольшая справка по его использованию:

```lua
-- Основной вызов Lazy.nvim
require("lazy").setup(opts)

-- Где opts — это таблица (массив) с описаниями плагинов.
-- Каждый элемент таблицы описывает один плагин.

{
  -- Указывается репозиторий плагина на GitHub
  "github_user/repo",

  -- Необязательное поле: зависимости (будут установлены автоматически)
  dependencies = {
    "github_user/dependency1",
    "github_user/dependency2",
    -- и т.д.
  },

  -- Настройка плагина: вызывается при его загрузке
  -- Можно использовать для ручной инициализации, настройки событий и т.д.
  config = function()
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
}

-- Альтернатива: можно передать путь к модулю, экспортирующему список плагинов
require("lazy").setup("path.to.plugins")

-- Где path/to/plugins.lua может выглядеть как:
return {
  {
    "github_user/foo",
    opts = {},
  },
  {
    "github_user/bar",
    config = function()
      require("bar").setup()
    end,
  },
}

-- Или если в каталоге `lua/path/to/plugins/` несколько файлов:
-- каждый файл экспортирует таблицу(ы) с описанием плагинов:
-- plugins/foo.lua:
return {
  "github_user/foo",
  opts = {},
}

-- plugins/bar.lua:
return {
  "github_user/bar",
  config = true,
}

-- Ошибка: модуль не найден
local foo = require("foo")
require("lazy").setup({ ... })

-- Так же приведет к ошибке, так как модуль ленивый
require("lazy").setup({
  {
    "github_user/foo",
    lazy = true, -- это значение по умолчанию
  },
})

local foo = require("foo")

-- Таким образом, самый надежный вариант
{
  "github_user/foo",
  dependencies = { "github_user/bar" },  -- зависимости тоже гарантированно доступны для загрузки
  config = function()
    local foo = require("foo")
    foo.setup {}
    local bar = require("bar")
    bar.setup()
  end,
}
```

#### Удаление плагинов, кеша и тп

```sh
rm -rf ~/.local/share/nvim
```
