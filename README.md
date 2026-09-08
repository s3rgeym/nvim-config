# Neovim 0.12+ Config

<img width="1120" height="788" alt="image" src="https://github.com/user-attachments/assets/e1b2c012-78af-4478-bc5e-e7033da25fc5" />
<img width="1120" height="788" alt="image" src="https://github.com/user-attachments/assets/1591d239-b094-4036-8819-6c9e8c4cc454" />

Минималистичный конфиг для **Neovim 0.12+**, использующий встроенные возможности редактора вместо сторонних плагинов.

## Особенности

- Легкая и понятная структура конфигураций:
  - Конфигурации, подключаются вручную в `init.lua`, так как важен порядок их
    подключения.
  - Плагины лежат в `plugin/` и загружаются автоматически (их загрузка
    происходит после конфигураций).
  - Настройки языковых серверов расширяются в `after/lsp/`. Если требуется
    полностью их переопределить, то файлы-конфиги нужно кидать в `lsp/`.
  - `ftplugin/` служит для задания настроек для опр типов файлов.
- Используется встроенный пакетный менеджет `vim.pack`.
- Сочетания клавиш или как правильно говорить биндинги не конфликтуют с Zellij.
- Из коробки настроено автодополнение для стека типичной веб-макаки.
- Установка парсеров **TreeSitter** (для работы с синтаксическим деревом для
  рефакторинга и тп), языковых серверов, инструментов для форматирования и пр осуществляется через
  **Mason**.
- Доступные сочетания можно посмотреть через **which-key** (если нажать
  `<leader>`, `<C-w>` и пр, то отобразятся доступные сочетания).
- В качестве файлового менеджера используется **oil.nvim** (клавиша `-`). Его
  особенностью является возможность работать со списком файлов как с буфером: переходим в режим редактирования, изменяем имя, сохраняем буфер, и имя файла меняется. Так же если, удалить строку, то файл будет удален, добавить — создан.
- Для поиска вместо громоздкого **Telescope** используется **fzf-lua** (требует
  в наличии установленного **fzf**).
- Для работы с Git применяется **lazygit** (требует установки одноименной
  утилиты).
- Для форматирования применяется **conform**. Он нужен так как не все популярные
  инструменты для форматирования поддерживают работу через LSP. Если вы пишите только на питон, то этот плагин можно выбросить, так как **ruff** работает через LSP.
- Есть плагин для рефакторинга.
- Отображается markdown.
- Можно просматривать изображения (у меня терминал поддерживает только sixel, более
  современные терминалы типа ghostty работают с kitty).
- Я не стал добавлять отладку через **dap**. В этом нет смысла: что-то сложное
  нужно разрабатывать через тестирование.

По итогу: конфиг довольно минималистичен и может быть взят за основу своего. Я одно время пользовался helix, но он кривой, и многие привычные вещи недоступны либо делаются странным образом... Хотя тут его напомнить может разве что всплывающие подсказки с сочетаниями.

## Установка

```sh
# Резервное копирование старого конфига
mv ~/.config/nvim{,.old}
git clone https://github.com/s3rgeym/nvim-config ~/.config/nvim

# Либо использование этого конфига через NVIM_APPNAME
git clone https://github.com/s3rgeym/nvim-config ~/.config/s3rgeym-nvim
NVIM_APPNAME=s3rgeym-nvim nvim
```

После первого запуска рекомендуется:

1. Установить LSP‑серверы и инструменты через `:Mason`
2. Установить все Tree‑sitter парсеры командой:

```vim
:TSInstall all
```

## Рецепты

### Автоматические сохранение и восстановление темы

Я этот функционал удалил из конфига, так он излишен:

```lua
-- Автоматически сохраняет и загружает цветовую схему,
-- установленную через :colorscheme.
local theme_file = vim.fn.stdpath('config') .. '/theme.json'
local fallback = 'habamax'

local function load_theme()
  local f = io.open(theme_file, 'r')
  if not f then
    return
  end

  local ok, data = pcall(vim.json.decode, f:read('*a'))
  f:close()

  return ok and type(data) == 'table' and data.colorscheme or nil
end

local function save_theme(theme)
  local json = vim.fn.json_encode({ colorscheme = theme })
  pcall(vim.fn.writefile, { json }, theme_file)
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Save selected color scheme to JSON file',
  callback = function(args)
    save_theme(args.match)
  end,
})

-- VimEnter необходим, так как плагины из ~/.config/nvim/plugin
-- загружаются после init.lua. Поэтому пользовательская тема может
-- быть применена только после того, как все плагины добавили свои темы.
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load saved color scheme after all plugins are loaded',
  callback = function()
    local theme = load_theme() or fallback

    if not pcall(vim.cmd.colorscheme, theme) then
      vim.cmd.colorscheme(fallback)
      save_theme(fallback)
    end
  end,
})
```

Тут стоило тему хранить в lua-файле что-то типа:

```lua
return 'mytheme'
```
