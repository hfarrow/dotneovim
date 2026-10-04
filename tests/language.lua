local tools = require('config.tools')
for name, version in pairs(tools.manifest) do
  local receipt = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', name, 'mason-receipt.json')), '\n'))
  assert(receipt.source.id:find('@' .. version, 1, true), name .. ' version')
end
assert(vim.fn.exepath('lua-language-server') == tools.path('lua-language-server'), 'Managed PATH precedence')
assert(not require('mason.settings').current.registry_cache.refresh)
assert(not require('blink.cmp.config').fuzzy.prebuilt_binaries.download)
local fixture = vim.fn.tempname() .. ' language space'
vim.fn.mkdir(fixture, 'p')
vim.fn.mkdir(fixture .. '/.git', 'p')
vim.fn.writefile({ '{}' }, fixture .. '/package.json')
vim.fn.writefile({ '[tool.ruff]', 'line-length = 88' }, fixture .. '/pyproject.toml')
vim.fn.mkdir(fixture .. '/.venv/bin', 'p')
assert(vim.uv.fs_symlink(vim.fn.exepath('python3'), fixture .. '/.venv/bin/python'))
vim.fn.mkdir(fixture .. '/node_modules', 'p')
assert(vim.uv.fs_symlink(vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'typescript-language-server', 'node_modules', 'typescript'), fixture .. '/node_modules/typescript'))
local cases = {
  { 'test.sh', 'bashls', { '#!/usr/bin/env bash', 'hello() { echo hi; }', 'hello', 'echo $undefined_variable' }, 2, 1 },
  { 'test.ts', 'ts_ls', { 'function hello(value: number) { return value; }', 'const result = hello(1);' }, 1, 17 },
  { 'test.lua', 'lua_ls', { 'local function hello(value)', '  return value', 'end', 'hello(1)' }, 3, 1 },
  { 'test.py', 'pyright', { 'def hello(value: int) -> int:', '    return value', 'result = hello(1)' }, 2, 11 },
}
local clients = {}
for _, case in ipairs(cases) do
  local file = fixture .. '/' .. case[1]
  vim.fn.writefile(case[3], file)
  vim.cmd.edit(file)
  local buf = vim.api.nvim_get_current_buf()
  local client
  assert(vim.wait(15000, function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf, name = case[2] })) do if c.initialized then client = c; return true end end
  end, 50), 'Real initialization: ' .. case[2] .. ' ' .. vim.inspect(vim.lsp.get_clients()))
  clients[#clients + 1] = client
  assert(client.config.capabilities.textDocument.completion.completionItem.snippetSupport, 'Capabilities prepared before server')
  assert(client.config.cmd[1]:find('/mason/bin/', 1, true), 'Managed process')
  assert(not client.server_capabilities.documentFormattingProvider, 'Single future formatting owner')
  local params = { textDocument = { uri = vim.uri_from_bufnr(buf) }, position = { line = case[4], character = case[5] } }
  local response
  assert(vim.wait(10000, function()
    response = client:request_sync('textDocument/definition', params, 1000, buf)
    return response and not response.err and response.result and not vim.tbl_isempty(response.result)
  end, 100), 'Real definition: ' .. case[2] .. ' ' .. vim.inspect(response))
  if case[2] == 'bashls' then
    assert(vim.wait(10000, function()
      for _, d in ipairs(vim.diagnostic.get(buf)) do if tostring(d.code):find('2154') or d.message:find('referenced but not assigned') then return true end end
    end, 50), 'Real ShellCheck diagnostic')
  end
  if case[2] == 'pyright' then
    assert(vim.fs.normalize(client.config.settings.python.pythonPath):gsub('^/private', '') == (fixture .. '/.venv/bin/python'):gsub('^/private', ''), 'Real client project interpreter')
    assert(vim.wait(10000, function()
      local c = vim.lsp.get_clients({ bufnr = buf, name = 'ruff' })[1]
      return c and c.initialized and c.server_capabilities.hoverProvider == false
    end, 50), 'Real Ruff handshake, hover ownership')
  end
  if case[2] == 'ts_ls' then assert(vim.uv.fs_realpath(client.config.init_options.tsserver.path) == vim.uv.fs_realpath(fixture .. '/node_modules/typescript/lib/tsserver.js'), 'Real project compiler') end
end
for _, ext in ipairs({ 'cs', 'rs', 'zsh' }) do
  local file = fixture .. '/syntax.' .. ext
  vim.fn.writefile({ 'syntax only' }, file)
  vim.cmd.edit(file)
  vim.wait(100)
  assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, 'No semantic client: ' .. ext)
end
local file = fixture .. '/large.lua'
vim.fn.writefile({ string.rep('x', 10001) }, file)
vim.cmd.edit(file)
vim.wait(100)
assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, 'Large-file LSP exclusion')
local config = vim.diagnostic.config()
assert(config.virtual_text == false and config.virtual_lines == false and config.signs)
assert(vim.fn.maparg('gr', 'n') == '', 'Native gr prefixes unblocked')
assert(vim.filetype.match({ filename = fixture .. '/.zshrc' }) == 'zsh')
assert(require('config.lsp').python(fixture) == fixture .. '/.venv/bin/python')
vim.fn.delete(fixture .. '/node_modules/typescript')
vim.fn.writefile({ '{"devDependencies":{"typescript":"7.0.2"}}' }, fixture .. '/package.json')
local compiler, warning = require('config.lsp').tsserver(fixture)
assert(not compiler and warning:find('<7'), 'Project compiler never substituted')
for _, client in ipairs(vim.lsp.get_clients()) do client:stop(true) end
vim.fn.delete(fixture, 'rf')
print('PASS: exact tool receipts/managed precedence, actual Bash/TS/Lua/Pyright/Ruff handshakes and definitions, ShellCheck, diagnostics and exclusion/interpreter/compiler policy')
vim.cmd('qa!')
