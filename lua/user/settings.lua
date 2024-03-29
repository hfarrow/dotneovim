local env = require('user.env')
local fn = require('user.functions')
local s = vim.opt
local autocmd = fn.autocmd_helper('settings_cmds', { clear = true })

-- Allow sensible setting to be overriden
-- Normally they are sourced after init.vim.
vim.cmd('runtime! plugin/sensible.vim')

if not env.tempdir then
  -- Don't use temp files
  s.swapfile = false
  s.backup = false
end

-- leader
vim.g.mapleader = ' '

------------------------------------------------------------------------------------------------------------------------
-- Formatting
------------------------------------------------------------------------------------------------------------------------
s.textwidth = 120
-- remove comment leader when [j]oining lines
-- [tc] auto-wrap text and comments using 'textwidth'
-- [ro] automatically insert comment leader hitting <Enter> in insert mode or after 'o' and 'O' in normal mode
-- [q] allow formatting comments with 'gq'
-- [l]ong lines are not broken in insert mode when a line was longer than 'textwidth'
s.formatoptions = 'jtcroql'
s.list = true
s.wrap = false

-- Tab set to two spaces
s.tabstop = 2
s.shiftwidth = 2
s.softtabstop = 2
s.expandtab = true
s.smartindent = true
s.autoindent = true
s.shiftround = true

------------------------------------------------------------------------------------------------------------------------
-- Display
------------------------------------------------------------------------------------------------------------------------
s.number = true
s.hlsearch = true
s.cursorline = true
s.signcolumn = 'auto'
s.visualbell = true
s.title = true
s.listchars:append('trail:⌴')
s.signcolumn = 'yes'

------------------------------------------------------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------------------------------------------------------
-- Set grep default grep command with ripgrep
s.grepprg = 'rg --vimgrep --follow'

-- Ignore the case when the search pattern is all lowercase
s.smartcase = true
s.ignorecase = true

------------------------------------------------------------------------------------------------------------------------
-- Misc
------------------------------------------------------------------------------------------------------------------------
-- When opening a window put it right or below the current one
s.splitright = true
s.splitbelow = true

-- Enable mouse support
s.mouse = 'a'

-- Insert mode completion setting
s.completeopt = { 'menu', 'menuone' }

s.errorformat:append('%f:%l:%c%p%m')
s.autowrite = true
s.colorcolumn = '+1'
s.backup = true

-- Allow pasting from OS clipboard with 'P'
-- Sometimes this will hang the entire terminal. Apparently xsel might work better than xclip but xsel makes nvim
-- hang at startup. </shrug>
--s.clipboard:append('unnamedplus')

-- Time out on key codes but not mappings
s.timeout = false
s.ttimeout = true
s.ttimeoutlen = 10

if vim.fn.exists('+undofile') then
  s.undofile = true
end
s.backupdir:remove('.')

s.spelllang = { 'en_us' }

------------------------------------------------------------------------------------------------------------------------
-- Auto Commands
------------------------------------------------------------------------------------------------------------------------
autocmd('InsertEnter', {
  desc = "Hide trailing white space when entering insert mode",
  command = ':set listchars-=trail:⌴'
})
autocmd('InsertLeave', {
  desc = "Show trailing white space when entering insert mode",
  command = ':set listchars+=trail:⌴'
})

autocmd({ 'WinLeave', 'InsertEnter' }, {
  desc = 'Hide cursor line in insert mode',
  command = 'set nocursorline'
})
autocmd({ 'WinEnter', 'InsertLeave' }, {
  desc = 'Show cursor line outside insert mode',
  command = 'set cursorline'
})

autocmd('BufReadPost', {
  desc = 'Make sure vim returns to the same line when you reopen a file',
  callback = function(args)
    vim.cmd([[
      if line("'\"") > 0 && line("'\"") <= line("$")
        execute 'normal! g`"zvzz'
      endif
    ]])
  end
})

autocmd('FocusLost', {
  desc = 'Save when losing focus',
  command = ':silent! wall'
})

autocmd({ 'FocusGained', 'BufEnter' }, {
  desc = 'Reload when gaining focus',
  command = ':silent! checktime'
})

autocmd('VimResized', {
  desc = 'Resize splits when the window is resized',
  command = ':wincmd ='
})

------------------------------------------------------------------------------------------------------------------------
-- Theme
------------------------------------------------------------------------------------------------------------------------
if vim.fn.has('termguicolors') == 1 then
  s.termguicolors = true
end

-- :h gruvbox-material

vim.g.gruvbox_material_foreground = 'material'
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = 1

-- Active theme (must be after the configuration above)
vim.cmd('colorscheme gruvbox-material')
