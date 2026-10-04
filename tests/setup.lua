local tools = require('config.tools')
for _, name in ipairs({ 'ruff', 'shellcheck', 'lua-language-server', 'stylua', 'shfmt', 'black' }) do
  assert(tools.suffix(name, true) == '.exe', name)
  assert(tools.suffix(name, false) == '', name)
end
for _, name in ipairs({ 'bash-language-server', 'typescript-language-server', 'pyright-langserver', 'prettier', 'vscode-eslint-language-server' }) do
  assert(tools.suffix(name, true) == '.cmd', name)
end
for _, dir in ipairs({ '.venv', 'venv' }) do
  assert(tools.venv_executable('/project/' .. dir, 'python', true) == '/project/' .. dir .. '/Scripts/python.exe')
  assert(tools.venv_executable('/project/' .. dir, 'ruff', true) == '/project/' .. dir .. '/Scripts/ruff.exe')
  assert(tools.venv_executable('/project/' .. dir, 'python', false) == '/project/' .. dir .. '/bin/python')
end
local fixture = vim.fn.tempname() .. ' python space'
vim.fn.mkdir(fixture, 'p')
local result = vim.system({ vim.fn.exepath('python3'), '-m', 'venv', fixture .. '/venv' }, { text = true }):wait(10000)
assert(result.code == 0, result.stderr)
assert(require('config.lsp').python(fixture) == fixture .. '/venv/bin/python')
result = vim.system({ require('config.lsp').python(fixture), '-c', 'import sys; assert sys.prefix != sys.base_prefix' }, { text = true }):wait(2000)
assert(result.code == 0, result.stderr)
vim.fn.delete(fixture, 'rf')
local health = require('config.health')
local report = health.report()
for _, item in ipairs(report) do assert(item.ok or item.optional, vim.inspect(item)) end
local original = tools.path
tools.path = function(name) return '/missing setup fixture/' .. name end
local missing = health.report()
tools.path = original
local failures = 0
for _, item in ipairs(missing) do
  if item.name:match('^Tool ') then
    assert(not item.ok and item.remedy:find('scripts/tools.lua', 1, true), vim.inspect(item))
    failures = failures + 1
  end
end
assert(failures == vim.tbl_count(tools.manifest))
local lockpath = vim.fs.joinpath(vim.g.dotneovim_root, 'lazy-lock.json')
local readfile = vim.fn.readfile
vim.fn.readfile = function(path, ...)
  if path == lockpath then return { '{"lazy.nvim":{"commit":"incorrect-revision"}}' } end
  return readfile(path, ...)
end
local mismatch = health.report()
vim.fn.readfile = readfile
for _, item in ipairs(mismatch) do
  if item.name == 'Plugin lazy.nvim' then assert(not item.ok and item.remedy:find('scripts/install.lua', 1, true)) end
end
vim.cmd('SetupHealth')
assert(vim.wait(5000, function() return vim.bo.filetype == 'checkhealth' end))
assert(vim.v.errmsg == '', vim.v.errmsg)
print('PASS: complete/missing/mismatch health, native health UI, reviewed platform paths and real Mac virtualenv')
vim.cmd('qa!')
