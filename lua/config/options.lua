-- https://gist.github.com/echasnovski/fa70dc75c475369747d2a485a13303fb
-- У меня был соблазн все это в массив загнать, а потом задать значения для
-- vim.opt, но из-за того, что порядок задания некоторых значений не
-- соблюдается, то возникают странные баги

local o = vim.opt

-- Interface
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes'
o.laststatus = 3
o.shortmess:append('I')
o.conceallevel = 0
o.showmode = false
o.showtabline = 1
-- Без popup справка не отображается
o.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }
-- В всплывающем окне с просмотром доументации края прямоугольные.
-- https://github.com/neovim/neovim/issues/38248#issuecomment-4038192073
o.pumborder = 'rounded'
o.winborder = 'rounded'
-- Эта опция влияет на задержку перед появлением всплывающего окна
o.updatetime = 200
-- Красная линия
-- o.colorcolumn = '+1'

-- Включается автоматически, но требутся явная установка для некоторых плагинов
if vim.fn.has('termguicolors') == 1 then
  o.termguicolors = true
end

-- Cursor
o.scrolloff = 8
o.sidescrolloff = 8
o.whichwrap = 'h,l,<,>,[,]'
o.mouse = 'a'

-- Text
o.wrap = false
-- o.linebreak = true
-- o.breakindent = true
-- o.showbreak = '↪ '
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 2
o.softtabstop = 2
o.smarttab = true
o.autoindent = true
o.smartindent = true
-- o.textwidth = 80
-- o.joinspaces = false
-- Не имеет эффекта в арче, так как устанавливается через системные плагины
-- после загрузки init.lua
-- o.formatoptions = { j = true, q = true }
o.list = true
o.listchars:append({
  extends = '↪',
  -- lead = '·',
  nbsp = '␣',
  precedes = '↩',
  tab = '→ ',
  trail = '·',
})
o.synmaxcol = 255

-- Search
-- Эти 4 настройки включены по дефолту
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

o.inccommand = 'split'
o.wildignorecase = true
o.wildignore:append({
  '*/.git/*',
  '*/node_modules/*',
})

-- Files
o.clipboard = 'unnamedplus'
o.swapfile = false
o.backup = false
o.undofile = true
o.hidden = true -- дефолт
o.autoread = true -- дефолт
o.confirm = true
-- Отключает modeline во избежание инъекции команд через содержимое файлов
o.modeline = false
-- options не сохраняются в сессиях во избежание конфликтов с плагинами
o.sessionoptions =
  'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
-- Хранит позицию курсора, метки и регистры между сессиями
o.shada = "!,'100,<1000,s10,h"

-- Windows
o.splitbelow = true
o.splitright = true

-- Performance
o.timeoutlen = 500

-- Русская раскладка
-- Переключение встроенной раскладки через <C-^>
o.keymap = 'russian-jcukenwin'
o.iminsert = 0
o.imsearch = -1
-- Сочетания клавиш работают при любой активной раскладке
o.langmap =
  [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]
