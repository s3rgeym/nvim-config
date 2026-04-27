-- Эти настройки применяются до загрузки плагинов
-- Leader нужно объявить до их инициализации
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- У меня был соблазн все это в массив загнать, а потом задать значения для
-- vim.opt, но из-за того, что порядок задания значений не соблюдается,
-- возникают странные баги

local o = vim.opt

-- Interface
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes'
o.laststatus = 3
o.shortmess:append('I')
o.conceallevel = 0
-- opt.showmode = false
-- opt.showtabline = 2

if vim.fn.has('termguicolors') == 1 then
  o.termguicolors = true
end

-- Cursor
o.scrolloff = 8
o.sidescrolloff = 8
o.whichwrap = 'h,l,<,>,[,]'
o.mouse = 'a'

-- Text
o.wrap = true
o.linebreak = true
o.breakindent = true
o.showbreak = '↪ '
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 2
o.softtabstop = 2
o.smarttab = true
o.autoindent = true
o.smartindent = true
o.textwidth = 80
-- opt.joinspaces = false
-- Не имеет эффекта в арче, так как устанавливается через плагины после загрузки init.lua
-- opt.formatoptions = { j = true, q = true }
o.list = true
o.listchars:append({
  extends = '↪',
  lead = '·',
  nbsp = '␣',
  precedes = '↩',
  tab = '→ ',
  trail = '·',
})

-- Search
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

-- Completion
o.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }
o.backspace = { 'indent', 'eol', 'start' }
-- o.pummaxwidth = 40
o.pumborder = 'rounded'

-- Files
o.clipboard = 'unnamedplus'
o.swapfile = false
o.backup = false
o.undofile = true
o.hidden = true
o.autoread = true
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
o.updatetime = 200
o.timeoutlen = 500

-- Русская раскладка
-- Переключение встроенной раскладки через <C-^>
o.keymap = 'russian-jcukenwin'
o.iminsert = 0
o.imsearch = -1
-- Сочетания клавиш работают при любой активной раскладке
o.langmap =
  [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]
