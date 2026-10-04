-- Explicit test dependencies in the isolated validation environment only.
local base = assert(vim.env.DOTNEOVIM_TEST_HOME)
local path = base .. '/format-project'
vim.fn.mkdir(path, 'p')
vim.fn.writefile({ '{"private":true,"devDependencies":{"prettier":"3.9.9","@biomejs/biome":"2.5.15","eslint":"9.39.4"}}' }, path .. '/package.json')
local result = vim.system({ 'npm', 'install', '--ignore-scripts', '--no-audit', '--no-fund' }, { cwd = path, text = true }):wait(120000)
assert(result.code == 0, result.stderr)
print(result.stdout)
