-- https://gist.github.com/echasnovski/fa70dc75c475369747d2a485a13303fb
-- У меня был соблазн все это в массив загнать, а потом задать значения для
-- vim.opt, но из-за того, что порядок задания значений не соблюдается,
-- возникают странные баги

local opt = vim.opt

-- Interface
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.laststatus = 3
opt.shortmess:append('I')
opt.conceallevel = 0
-- opt.showmode = false
-- opt.showtabline = 2
-- Красная линия
-- opt.colorcolumn = '+1'

-- Включается автоматически, но требутся явная установка для некоторых плагинов
if vim.fn.has('termguicolors') == 1 then
  opt.termguicolors = true
end

-- Cursor
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.whichwrap = 'h,l,<,>,[,]'
opt.mouse = 'a'

-- Text
opt.wrap = false
-- opt.linebreak = true
-- opt.breakindent = true
-- opt.showbreak = '↪ '
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
-- opt.textwidth = 80
-- opt.joinspaces = false
-- Не имеет эффекта в арче, так как устанавливается через плагины после
-- загрузки init.lua
-- opt.formatoptions = { j = true, q = true }
opt.list = true
opt.listchars:append({
  extends = '↪',
  -- lead = '·',
  nbsp = '␣',
  precedes = '↩',
  tab = '→ ',
  trail = '·',
})
opt.synmaxcol = 255

-- Search
-- Эти 4 настройки включены по дефолту
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.inccommand = 'split'
opt.wildignorecase = true
opt.wildignore:append({
  '*/.git/*',
  '*/node_modules/*',
})

-- Completion
opt.backspace = { 'indent', 'eol', 'start' }
-- Без popup нативный LSP не показывает документацию
opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }
opt.pumborder = 'rounded'
opt.pummaxwidth = 60
-- o.pumwidth = 20
opt.winborder = 'rounded'

-- Files
opt.clipboard = 'unnamedplus'
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.hidden = true -- дефолт
opt.autoread = true -- дефолт
opt.confirm = true
-- Отключает modeline во избежание инъекции команд через содержимое файлов
opt.modeline = false
-- options не сохраняются в сессиях во избежание конфликтов с плагинами
opt.sessionoptions =
  'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
-- Хранит позицию курсора, метки и регистры между сессиями
opt.shada = "!,'100,<1000,s10,h"

-- Windows
opt.splitbelow = true
opt.splitright = true

-- Performance
opt.updatetime = 200
opt.timeoutlen = 500

-- Русская раскладка
-- Переключение встроенной раскладки через <C-^>
opt.keymap = 'russian-jcukenwin'
opt.iminsert = 0
opt.imsearch = -1
-- Сочетания клавиш работают при любой активной раскладке
opt.langmap =
  [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]

-- print('options loaded!')
