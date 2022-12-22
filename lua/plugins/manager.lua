local fn = require('user.functions')
local autocmd = fn.autocmd_helper('plugins_manager_cmds', {clear = true})

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local augroup = vim.api.nvim_create_augroup('packer_user_config', {clear = false})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup,
  desc = 'Compile Packer on config save',
  pattern = {'plugins.lua', 'manager.lua'},
  callback = function (args)
    local fn = require('user.functions')
    vim.api.nvim_command('source '..fn.get_dotneovim_path('lua/user/plugins.lua'))
    vim.api.nvim_command('source <afile>')
    vim.api.nvim_command('PackerCompile')
  end
})

local packer_bootstrap = ensure_packer()
local user_plugins = require('user/plugins')
return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  require('user.plugins')(use)

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
