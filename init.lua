-- Load the "env" file or log an error
local ok, env = pcall(require, 'user.env')
if not ok then
  vim.notify(
    'lua/user/env.lua not found.',
    vim.log.levels.ERROR
  )
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic editor options
require('user.settings')

-- User defined commands
require('user.commands')

-- Plugins
require('plugins.manager')

-- Keybindings
require('user.keymaps')

-- Plugin management and config
require('user.plugins')
