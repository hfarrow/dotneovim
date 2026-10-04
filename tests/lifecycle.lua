assert(not vim.g.unmanaged_legacy_loaded, 'Unmanaged start package loaded')
assert(vim.fn.filereadable(vim.fn.stdpath('data') .. '/site/pack/legacy/start/sentinel/plugin/sentinel.lua') == 1, 'Sentinel must exist for this check')
local config = require('lazy.core.config')
assert(config.options.install.missing == false, 'Startup installation enabled')
assert(config.options.checker.enabled == false, 'Background updates enabled')
for _, plugin in pairs(config.plugins) do
  assert(not plugin._.tasks or #plugin._.tasks == 0, 'Startup scheduled dependency tasks')
end
local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.g.dotneovim_root .. '/lazy-lock.json'), '\n'))
for name, entry in pairs(lock) do
  local result = vim.system({ 'git', '-C', vim.fn.stdpath('data') .. '/lazy/' .. name, 'rev-parse', 'HEAD' }, { text = true }):wait()
  assert(result.code == 0 and vim.trim(result.stdout) == entry.commit, name .. ' differs from lock')
end
print('PASS: provisioned startup uses locked plugins, no install/update work; legacy package retained and unloaded')
vim.cmd('qa!')
