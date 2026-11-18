-- Общие настройки
-- Самые частые значения в конфигах
-- https://github.com/neovim/neovim/issues/21342
-- https://gist.github.com/echasnovski/fa70dc75c475369747d2a485a13303fb
-- У меня был соблазн все это в массив загнать, а потом задать значения для
-- vim.opt, но из-за того, что порядок задания некоторых значений не
-- соблюдается, то возникают странные баги
local g = vim.g
local o = vim.opt

-- Клавиша Leader
g.mapleader = ' '
g.maplocalleader = ' ' -- Часто его делают ',' или '\\'

--------------------------------------------------------------------------------
-- Performance & Timing
--------------------------------------------------------------------------------
o.timeoutlen = 1000
o.updatetime = 300 -- Эта опция влияет на задержку перед появлением всплывающего окна
o.redrawtime = 1500 -- Лимит времени на отрисовку и подсветку синтаксиса в длинных строках (мс)
o.ttimeoutlen = 50 -- Задержка после нажатия Esc (убирает лаг при выходе из режима вставки)

--------------------------------------------------------------------------------
-- UI & Windows
--------------------------------------------------------------------------------
-- Включается автоматически, но требуется явная установка для некоторых плагинов
if vim.fn.has('termguicolors') == 1 then
  o.termguicolors = true
end

o.number = true
o.relativenumber = true
o.cursorline = true
-- o.signcolumn = 'yes'
-- o.colorcolumn = '+1' -- Красная линия
o.showmode = false -- Не отображаем режим, вместо этого переносим его в statusline
o.laststatus = 3
-- В tabline можно показывать имя файла вместо строки статуса, если лишнюю
-- строку не жалко
-- Для отключения табов
-- o.showtabline = 0
o.shortmess:append('Ic')
o.conceallevel = 0
o.pumheight = 10 -- Ограничивает высоту выпадающего списка автодополнения (чтобы не перекрывал экран)

o.splitbelow = true
o.splitright = true
o.splitkeep = 'screen' -- Сохраняет визуальное положение строк при открытии/закрытии сплитов

-- В всплывающем окне с просмотром документации края прямоугольные.
-- https://github.com/neovim/neovim/issues/38248#issuecomment-4038192073
o.pumborder = 'rounded'
o.winborder = 'rounded'

--------------------------------------------------------------------------------
-- Editing & Navigation
--------------------------------------------------------------------------------
o.scrolloff = 8
o.sidescrolloff = 8
o.whichwrap = 'h,l,<,>,[,]'
-- Полезно только при выделении через Ctrl-V
o.virtualedit = 'block'
o.mouse = 'a'
o.jumpoptions = 'view' -- Сохраняет положение скролла при перемещении по истории прыжков (Ctrl-O / Ctrl-I)

o.expandtab = true
o.tabstop = 4
o.shiftwidth = 2
o.softtabstop = 2
o.smarttab = true
o.autoindent = true
o.smartindent = true

o.wrap = false
-- o.linebreak = true
-- o.breakindent = true
-- o.showbreak = '↪ '
-- o.textwidth = 80
-- o.joinspaces = false
-- Не имеет эффекта в Арче, так как устанавливается через системные плагины
-- после загрузки init.lua
-- o.formatoptions = { j = true, q = true }

o.list = true
o.listchars:append({
  tab = '→ ',
  trail = '·',
  nbsp = '␣',
  extends = '›',
  precedes = '‹',
  -- lead = "·",
  -- eol = "↲",
})
o.synmaxcol = 300

--------------------------------------------------------------------------------
-- Completion & Search
--------------------------------------------------------------------------------
-- Без popup справка не отображается
-- Возможно, стот это вынести в настройки LSP
o.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }

-- Эти 4 настройки включены по дефолту
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

o.inccommand = 'split'

o.wildignorecase = true
o.wildignore:append({
  -- VCS
  '*/.git/*',
  '*/.hg/*',
  '*/.svn/*',

  -- зависимости и сборка
  '*/node_modules/*',
  '*/dist/*',
  '*/build/*',
  '*/target/*',
  '*/vendor/*',
  '*/.next/*',
  '*/.nuxt/*',

  -- python
  '*/__pycache__/*',
  '*.pyc',
  '*/.venv/*',
  '*/venv/*',

  -- кэши и IDE
  '*/.cache/*',
  '*/.idea/*',
  '*/.vscode/*',

  -- бинарники и артефакты
  '*.o',
  '*.obj',
  '*.so',
  '*.dll',
  '*.exe',
  '*.class',

  -- медиа и архивы
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.gif',
  '*.pdf',
  '*.zip',
  '*.tar',
  '*.gz',

  -- мусор системы
  '*.swp',
  '*~',
  '.DS_Store',
})

--------------------------------------------------------------------------------
-- Files & System
--------------------------------------------------------------------------------
o.clipboard = 'unnamedplus'

o.undofile = true
o.undolevels = 10000 -- Увеличивает максимальное количество шагов для отмены изменений (u)
-- Хранит позицию курсора, метки и регистры между сессиями
o.shada = "!,'100,<1000,s10,h"
-- Claude советовыал добавить, но то скорее его бред
o.sessionoptions:append('localoptions')

o.swapfile = false
o.backup = false
o.hidden = true -- дефолт
o.autoread = true -- дефолт
o.confirm = true
-- Отключает modeline во избежание инъекции команд через содержимое файлов
o.modeline = false

--------------------------------------------------------------------------------
-- Русская раскладка
--------------------------------------------------------------------------------
-- Переключение встроенной раскладки через <C-^>
o.keymap = 'russian-jcukenwin'
o.iminsert = 0
o.imsearch = -1
-- Сочетания клавиш работают при любой активной раскладке
o.langmap =
  [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]
