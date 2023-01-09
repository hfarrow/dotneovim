-- Load the "env" file or log an error
local ok, _ = pcall(require, 'user.env')
if not ok then
  vim.notify(
    'lua/user/env.lua not found.',
    vim.log.levels.ERROR
  )
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugin management and config
require('user.plugins')

-- basic editor options
require('user.settings')

-- User defined commands
require('user.commands')

-- Keybindings
require('user.keymaps')

