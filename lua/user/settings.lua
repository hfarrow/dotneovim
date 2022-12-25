local env = require('user.env')
local fn = require('user.functions')
local s = vim.opt
local autocmd = fn.autocmd_helper('settings_cmds', {clear = true})

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
-- Navigation
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Formatting
------------------------------------------------------------------------------------------------------------------------
--Don't break line after 1 letter word; break before if possible
s.textwidth = 120
s.formatoptions:append('1')  -- don't break a line after a one-letter word, break before if possible
-- TODO auto formatting comments was too strict. For example, in lua, I could not add a space after '--' and it was
-- making banners hard to edit. Maybe it can be per file type?
--s.formatoptions:append('ac') -- only autoformat comments
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
s.completeopt = {'menu', 'menuone'}

s.errorformat:append('%f:%l:%c%p%m')
s.autowrite = true
s.colorcolumn = '+1'
s.backup = true

-- Allow pasting from OS clipboard with 'P'
s.clipboard:append('unnamedplus')

-- Time out on key codes but not mappings
s.timeout = false
s.ttimeout = true
s.ttimeoutlen = 10

if vim.fn.exists('+undofile') then
  s.undofile = true
end
s.backupdir:remove('.')

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

autocmd({'WinLeave', 'InsertEnter'}, {
  desc = 'Hide cursor line in insert mode',
  command = 'set nocursorline'
})
autocmd({'WinEnter', 'InsertLeave'}, {
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

autocmd({'FocusGained', 'BufEnter'}, {
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
