-- Explicit provisioning; this file runs with nvim -l (without user startup).
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')))
local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(root, 'lazy-lock.json')), '\n'))
local path = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
local function run(args)
  local result = vim.system(args, { text = true }):wait()
  assert(result.code == 0, result.stderr or vim.inspect(args))
end
if not vim.uv.fs_stat(path) then
  run({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', path })
end
run({ 'git', '-C', path, 'checkout', lock['lazy.nvim'].commit })
vim.g.dotneovim_install = true
vim.o.loadplugins = true
dofile(vim.fs.joinpath(root, 'init.lua'))
require('lazy').install({ wait = true })
require('lazy').restore({ wait = true })
for _, plugin in ipairs(require('lazy').plugins()) do
  assert(vim.uv.fs_stat(plugin.dir), 'Installation failed: ' .. plugin.name)
  for _, task in ipairs(plugin._.tasks or {}) do assert(not task:has_errors(), 'Plugin task failed: ' .. plugin.name) end
end
print('Plugin provisioning complete. Restart Neovim.')
