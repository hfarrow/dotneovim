local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')))
vim.o.loadplugins = true
dofile(root .. '/init.lua')
local registry = require('mason-registry')
local ready, success = false, false
registry.update(function(ok) success, ready = ok, true end)
assert(vim.wait(120000, function() return ready end, 50) and success, 'Mason registry update failed')
for name, version in pairs(require('config.tools').manifest) do
  local package = registry.get_package(name)
  local receipt = package:get_receipt():or_else(nil)
  local installed = receipt and receipt.source and receipt.source.id or ''
  if not package:is_installed() or not installed:find('@' .. version, 1, true) then
    local finished, ok = false, false
    package:once('install:success', function() ok, finished = true, true end)
    package:once('install:failed', function() finished = true end)
    package:install({ version = version })
    assert(vim.wait(180000, function() return finished end, 50) and ok, 'Tool installation failed: ' .. name .. '@' .. version)
  end
  receipt = assert(package:get_receipt():or_else(nil))
  assert(receipt.source.id:find('@' .. version, 1, true), 'Unexpected tool receipt: ' .. name)
  print(name .. ': ' .. receipt.source.id)
end
print('Managed tool provisioning complete. Restart Neovim; no startup installs.')
