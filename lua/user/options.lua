-- Базовые настройки
-- See <https://neovim.io/doc/user/options.html>
local opt = vim.opt

-- Нумерация строк
opt.number = true
-- Мне не нравится нумерация относительно курсора
--opt.relativenumber = true

-- Подсветка текущей строки
opt.cursorline = true

-- Прокрутка
opt.scrolloff = 8     -- Сколько строк отображать после курсора при вертикальной прокрутке
opt.sidescrolloff = 8 -- Аналог для горизонтальной прокрутке (при wrap=true не имеет эффекта)

-- Отображение различных элементов
opt.signcolumn = "yes"
opt.showcmd = true
opt.laststatus = 3
opt.showmode = false      -- не показывать режим (--INSERT и тп) в самом низу
opt.shortmess:append("I") -- Простите, но мне глубоко поебать на Уганду

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

-- Отступы и форматирование текста
opt.expandtab = true -- заменять символы табуляции на пробелы при отрисовке
opt.tabstop = 4      -- на сколько пробелов заменяется символ табуляции при отображении
opt.shiftwidth = 2   -- количество пробелов, вставляемых при шифтинге
opt.softtabstop = 2  -- ширина отступа
-- автоматически определять количество пробелов для отступа
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true -- при переносе строки добавлять отступы
opt.textwidth = 80
-- граница на [textwidth]+N
opt.colorcolumn = "+1,+21"
opt.formatoptions = {
  c = true, -- форматировать комментарии по textwidth
  j = true, -- удалять лишние комментарии при J
  l = true, -- не форматировать длинные строки в Insert
  n = true, -- распознавать списки
  q = true, -- разрешить gq
  r = true, -- продолжить комментарий на новой строке
  t = true, -- переносить текст (нужно для переноса комментариев)
}

-- Поиск
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.wrapscan = true
opt.inccommand = "split"

opt.grepformat = "%f:%l:%c:%m"
-- Настройка ripgrep вместо grep
-- sudo pacman -S ripgrep
if vim.fn.executable('rg') == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
end

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

-- Фолдинг
-- `:set foldexpr` должен содержать treesitter по умолчанию
opt.foldmethod = "expr"
-- opt.foldtext = ""
opt.foldlevelstart = 99
opt.foldenable = true

-- Мышь, перемещение курсора и выделение текста
opt.mouse = "a"
opt.mousemoveevent = true
-- Привычное перемещение курсора
opt.whichwrap = 'h,l,<,>,[,]'
-- Выделение текста стрелками с зажатым Shifts
-- Со stopsel выделение блоков (Shit-V) стрелками не будет работать
opt.keymodel = "startsel,"

-- Поддержка русского языка ввода
-- При переключении системной раскладки перестают работать привязки клавиш.
-- Решением может быть использование встроенной русской раскладки в vim с переключением по Ctrl-6
opt.keymap = "russian-jcukenwin"
-- Делаем раскладкой по умолчанию английскую
opt.iminsert = 0
opt.imsearch = 0

-- Автодополнение
opt.wildmenu = true
opt.wildmode = "longest:full,full"
-- Можно исключить из дополнения определенные типы файлов, имеющие бинарный формат
opt.wildignore:append { '*.o', '*.obj', '*.py[co]', '.git/*', '__pycache__/*', 'dist/*', 'build/*', '*.so', '*.zip', '*.rar', '*.tar.*', '*.gz', '*.docx', '*.xlsx', '*.pdf', '*.jpg', '*.jpeg', '*.gif', '*.png', '*.mp3', '*.mp4', '*.webp' }
opt.completeopt = "menuone,noselect,noinsert"
opt.pumheight = 15 -- высота всплывающего меню с вариантами для дополнения

-- Таймауйты
opt.timeoutlen = 1000 -- для ввода сочетания
opt.updatetime = 250  -- всплывающие окна

-- spell
opt.spell = false
opt.spelllang = { "ru", "en" }

-- Этот каталог нужно создать
local spell_dir = vim.fn.stdpath('config') .. '/spell'
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, 'p')
end

-- Отображаем диагностические сообщения как виртуальный текст
vim.diagnostic.config({
  virtual_text = {
    -- prefix = function(diagnostic)
    --   if diagnostic.severity == vim.diagnostic.severity.ERROR then
    --     return ""  -- Nerd font icon for error
    --   elseif diagnostic.severity == vim.diagnostic.severity.WARN then
    --     return ""  -- Nerd font icon for warning
    --   elseif diagnostic.severity == vim.diagnostic.severity.INFO then
    --     return ""  -- Nerd font icon for info
    --   else
    --     return ""  -- Nerd font icon for hint
    --   end
    -- end,
    -- spacing = 2,
    severity = { min = vim.diagnostic.severity.WARN } -- отображаем только ошибки и предупреждения
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Цветовая схеме и оформление
opt.guifont = "JetBrainsMono Nerd Font:h12"
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor20"

if opt.termguicolors then
  opt.background = "dark"
  vim.cmd [[colorscheme tokyonight-storm]]
else
  vim.cmd.colorscheme('desert')
end
