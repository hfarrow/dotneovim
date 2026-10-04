if vim.g.vscode then
  print("Initializing Neovim for VS Code")
  -- Don't load autoload user plugins in VS Code
  local default_pp = vim.api.nvim_get_option('packpath')
  local user_pp = vim.fn.stdpath('data') .. '/site'
  -- Remove user_pp from default_pp
  local new_pp = default_pp:gsub(user_pp, '')
  vim.o.packpath = new_pp
  -- TODO: Have a different packer_compiled.lua path (plugins.lua) for VS Code and terminal so that VS Code plugins are allowed.
else
  print("Initializing Neovim for Terminal")

  local compiled_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua'
  if vim.fn.filereadable(compiled_path) == 1 then
    vim.cmd('luafile ' .. compiled_path)
  end

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
end

