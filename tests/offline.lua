local config = require('lazy.core.config')
assert(not config.options.install.missing and not config.options.checker.enabled)
assert(vim.g.colors_name == 'gruvbox-material')
for _, plugin in pairs(config.plugins) do
  assert(not plugin._.tasks or #plugin._.tasks == 0, 'Unexpected dependency task')
end
print('PASS: provisioned startup with unreachable network proxies')
vim.cmd('qa!')
