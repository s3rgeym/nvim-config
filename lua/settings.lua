local config_dir = vim.fn.stdpath('config')
local opt = vim.opt

-- Нумерация строк
opt.number = true
-- Мне не нравится нумерация относительно курсора
--opt.relativenumber = true

-- Подсветка текущей строки
opt.cursorline = true

-- Прокрутка
opt.scrolloff = 5     -- Сколько строк отображать после курсора при вертикальной прокрутке
opt.sidescrolloff = 5 -- Аналог для горизонтальной прокрутке (при wrap=true не имеет эффекта)

-- Отображение различных элементов
opt.signcolumn = "yes"
opt.showcmd = false
opt.laststatus = 3
opt.showmode = false -- не показывать режим (--INSERT и тп) в самом низу

-- Перенос строк
opt.wrap = true
opt.linebreak = true

-- Отображение различных символов
opt.list = true
opt.listchars = {
  tab = '→ ',
  trail = '·',
  nbsp = '␣',
  extends = '❯',
  precedes = '❮'
}
opt.fillchars = { eob = " " } -- вместо ~ отображаем просто пустые строки

-- Отступы и табуляция
opt.expandtab = true -- заменять символы табуляции на пробелы при отрисовке
opt.tabstop = 4      -- на сколько пробелов заменяется символ табуляции при отображении
opt.shiftwidth = 2   -- количество пробелов, вставляемых при шифтинге
opt.softtabstop = 2  -- ширина отступа
-- автоматически определять количество пробелов для отступа
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true -- при переносе строки добавлять отступы

-- Поиск
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.wrapscan = true
opt.inccommand = "split"

-- Файлы и буферы
-- В последнем nvim вроде всегда такое поведение
-- opt.hidden = true
-- Используем системный буфер для копирования текста
-- Требует наличия xclip или wl-copy!
opt.clipboard = "unnamedplus"
-- Бекапы, файлы подкачки, undo- и shada-файлы хранятся в ~/.local/state/nvim
-- Отключаем создание бекапов и файлов подкачки
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true -- Обновлять буфер при изменении файла извне
-- Делаем возможной отмену изменений уже после закрытия файла
opt.undofile = true
opt.undolevels = 1000
opt.shada = "!,'1000,<50,s10,h" -- ограничения для shada-файлов (от share data)
opt.confirm = true

-- Разделение окон
opt.splitbelow = true
opt.splitright = true

-- Мышь и работа с текстом
opt.mouse = "a"
opt.mousemoveevent = true
-- Выделение текста стрелками с зажатым Shift
opt.keymodel = "startsel,stopsel"
-- При переключении системной раскладки перестают работать привязки клавиш.
-- В vim можно включить встроенную русскую раскладку с переключением по Ctrl-6
opt.keymap = "russian-jcukenwin"
-- Делаем раскладкой по умолчанию английскую
opt.iminsert = 0
opt.imsearch = 0
-- Привычное перемещение курсора
opt.whichwrap = 'h,l,<,>,[,]'

-- Автодополнение
opt.wildmenu = true
opt.wildmode = "longest:full,full"
-- Можно исключить из дополнения определенные типы файлов, имеющие бинарный формат
opt.wildignore:append { '*.o', '*.obj', '*.py[co]', '.git/*', '__pycache__/*', 'dist/*', 'build/*', '*.so', '*.zip', '*.rar', '*.tar.*', '*.gz', '*.docx', '*.xlsx', '*.pdf', '*.jpg', '*.jpeg', '*.gif', '*.png', '*.mp3', '*.mp4', '*.webp' }
opt.completeopt = "menuone,noselect,noinsert"
opt.pumheight = 10 -- высота всплывающего меню с вариантами для дополнения

-- Таймауйты
opt.timeoutlen = 500
opt.updatetime = 250

-- spell
opt.spell = false
opt.spelllang = { "ru", "en" }

local spell_dir = config_dir .. '/spell'
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, 'p')
end

-- Цветовая схеме и формление
opt.termguicolors = true
opt.background = "dark"
vim.cmd [[colorscheme tokyonight]]
opt.guifont = "JetBrainsMono Nerd Font:h12"
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor20"

if vim.g.neovide then
  -- Тут какие-то специфические настройки
  -- use ~/.config/neovide/config.toml instead
end
