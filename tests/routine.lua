-- Process audit is installed by the harness before init.lua.
vim.defer_fn(function()
  local calls = vim.g.dotneovim_process_audit or {}
  for _, args in ipairs(calls) do
    local command = table.concat(args, ' ')
    assert(not command:find('curl') and not command:find('wget') and not command:find('git fetch')
      and not command:find('git clone') and not command:find('npm install') and not command:find('pip install'), command)
  end
  assert(not require('lazy.core.config').options.install.missing)
  assert(not require('lazy.core.config').options.checker.enabled)
  assert(not require('mason.settings').current.registry_cache.refresh)
  print('PASS: routine startup actual process audit; no curl/wget/clone/fetch/install/update work: ' .. vim.inspect(calls))
  vim.cmd('qa!')
end, 300)
