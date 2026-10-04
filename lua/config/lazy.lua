local path = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
if not vim.uv.fs_stat(vim.fs.joinpath(path, 'lua', 'lazy', 'init.lua')) then
  vim.schedule(function()
    vim.notify('Plugins not provisioned. Run: nvim -l ' .. vim.fs.joinpath(vim.g.dotneovim_root, 'scripts', 'install.lua'), vim.log.levels.WARN)
  end)
  return
end
vim.opt.runtimepath:prepend(path)
local lazy = require('lazy')
lazy.setup({ { import = 'plugins' } }, {
  lockfile = vim.fs.joinpath(vim.g.dotneovim_root, 'lazy-lock.json'),
  defaults = { lazy = true },
  install = { missing = false, colorscheme = { 'gruvbox-material' } },
  checker = { enabled = false },
  change_detection = { enabled = false, notify = false },
  performance = { rtp = { reset = false } },
})
if not vim.g.dotneovim_install then
  local missing = {}
  for _, plugin in ipairs(lazy.plugins()) do
    if not vim.uv.fs_stat(plugin.dir) then missing[#missing + 1] = plugin.name end
  end
  if #missing > 0 then
    vim.schedule(function()
      vim.notify('Missing plugins: ' .. table.concat(missing, ', ') .. '. Run nvim -l scripts/install.lua from the checkout.', vim.log.levels.WARN)
    end)
  end
end
