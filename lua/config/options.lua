vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt
opt.clipboard = ''
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.shiftround = true
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.list = true
opt.listchars:append({ trail = '⌴' })
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.mouse = 'a'
opt.title = true
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeout = true
opt.ttimeoutlen = 50
opt.autowrite = false
opt.autowriteall = false
opt.autoread = true
opt.undofile = true
opt.backup = true
opt.backupdir = vim.fs.joinpath(vim.fn.stdpath('state'), 'backup') .. '//'
opt.undodir = vim.fs.joinpath(vim.fn.stdpath('state'), 'undo') .. '//'
opt.directory = vim.fs.joinpath(vim.fn.stdpath('state'), 'swap') .. '//'
opt.textwidth = 120
opt.formatoptions = 'jroql'
opt.spelllang = { 'en_us' }
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.termguicolors = true
-- Do not set 'background': the TUI follows the terminal's appearance.
vim.filetype.add({ extension = { txt = 'text', log = 'log' } })
vim.filetype.add({ filename = { ['.zshrc'] = 'zsh', ['.zshenv'] = 'zsh', ['.zprofile'] = 'zsh', ['.zlogin'] = 'zsh', ['.zlogout'] = 'zsh' }, extension = { zsh = 'zsh' } })
