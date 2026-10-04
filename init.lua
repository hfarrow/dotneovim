-- Resolve this checkout even when started with -u /path/to/init.lua.
local source = debug.getinfo(1, 'S').source:sub(2)
vim.g.dotneovim_root = vim.fs.dirname(vim.fs.normalize(vim.fn.fnamemodify(source, ':p')))
vim.opt.runtimepath:prepend(vim.g.dotneovim_root)
-- lazy.nvim owns plugins. Leave historical Packer packages on disk, unloaded.
vim.o.packpath = vim.env.VIMRUNTIME

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')
