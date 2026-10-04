local fixture = assert(vim.env.DOTNEOVIM_TEST_HOME) .. '/format-project'
local policy = require('config.format_policy')
local function write(path, text) vim.fn.mkdir(vim.fs.dirname(path), 'p'); vim.fn.writefile(text, path) end
local function edit(path, text)
  if text then write(path, text) end
  vim.cmd.edit({ args = { path }, bang = true })
  return vim.api.nvim_get_current_buf()
end
local notify, messages = vim.notify, {}
vim.notify = function(msg) messages[#messages + 1] = msg end
write(fixture .. '/.git/keep', { '' })
write(fixture .. '/packages/pretty/package.json', { '{"devDependencies":{"prettier":"3.9.9"},"prettier":{"singleQuote":true,"semi":false}}' })
write(fixture .. '/packages/biome/package.json', { '{"devDependencies":{"@biomejs/biome":"2.5.15"}}' })
write(fixture .. '/packages/biome/biome.json', { '{"formatter":{"indentStyle":"space"},"linter":{"enabled":true},"assist":{"actions":{"source":{"organizeImports":"on"}}}}' })
local pretty = fixture .. '/packages/pretty/file.js'
local buf = edit(pretty, { 'const value={name:"hello"};' })
local chosen = assert(policy.resolve(buf))
assert(chosen.tool == 'prettier' and chosen.command[1]:find('node_modules/.bin/prettier', 1, true), 'Workspace local formatter')
vim.cmd.write()
assert(vim.fn.readfile(pretty)[1] == "const value = { name: 'hello' }", 'Real pinned Prettier config/save')
local biome = fixture .. '/packages/biome/file.js'
buf = edit(biome, { 'import z from "z";', 'import a from "a";', 'var unused={x:1};' })
assert(policy.resolve(buf).tool == 'biome', 'Nearest biome package')
vim.cmd.write()
local formatted = vim.fn.readfile(biome)
assert(formatted[1]:find('import z') and formatted[2]:find('import a') and formatted[3]:find('var unused'), 'No organize imports or lint fix on save')
assert(formatted[3] == 'var unused = { x: 1 };', 'Actual Biome format')
local biome_client
assert(vim.wait(10000, function()
  biome_client = vim.lsp.get_clients({ bufnr = buf, name = 'biome' })[1]
  return biome_client and biome_client.initialized
end, 50), 'Real Biome handshake')
assert(vim.wait(5000, function() return #vim.diagnostic.get(buf) > 0 end, 50), 'Real Biome diagnostics')
write(fixture .. '/packages/biome/.nvim-format.json', { '{"javascript":{"formatter":"prettier","version":"3.9.9"}}' })
assert(policy.resolve(buf).tool == 'prettier', 'Explicit override')
vim.fn.delete(fixture .. '/packages/biome/.nvim-format.json')
write(fixture .. '/packages/missing/package.json', { '{"devDependencies":{"prettier":"0.0.1"}}' })
buf = edit(fixture .. '/packages/missing/file.js', { 'const value={x:1};' })
local p, err = policy.resolve(buf)
assert(not p and err:find('differs'), 'Version mismatch')
vim.cmd.write()
assert(vim.fn.readfile(vim.api.nvim_buf_get_name(buf))[1] == 'const value={x:1};', 'Mismatch save retains edits')
write(fixture .. '/packages/missing/package.json', { '{"devDependencies":{"prettier":"3.9.9","@biomejs/biome":"2.5.15"}}' })
p, err = policy.resolve(buf)
assert(not p and err:find('Ambiguous'), 'Competing owners')
write(fixture .. '/packages/lint/package.json', { '{"devDependencies":{"eslint":"9.39.4"}}' })
vim.fn.delete(fixture .. '/packages/lint/biome.json')
write(fixture .. '/packages/lint/eslint.config.cjs', { 'module.exports = [{ rules: { semi: ["error", "always"], "no-var": "error" } }];' })
local lintfile = fixture .. '/packages/lint/file.js'
buf = edit(lintfile, { 'var value=1' })
assert(not policy.resolve(buf), 'ESLint-only unformatted')
local client
assert(vim.wait(10000, function()
  client = vim.lsp.get_clients({ bufnr = buf, name = 'eslint' })[1]
  return client and client.initialized
end, 50), 'Real ESLint handshake')
assert(vim.wait(10000, function() return #vim.diagnostic.get(buf) > 0 end, 50), 'Real ESLint diagnostics')
vim.cmd.write()
assert(vim.fn.readfile(lintfile)[1] == 'var value=1', 'No lint fixes on save')
vim.cmd('LspEslintFixAll')
assert(vim.wait(3000, function() return vim.api.nvim_get_current_line():find(';') ~= nil end, 50), 'Explicit ESLint fix')
assert(not client.config.settings.format and not client.config.settings.codeActionOnSave.enable)
write(fixture .. '/packages/lint/biome.json', { '{"linter":{"enabled":true}}' })
vim.lsp.enable('biome', false)
vim.lsp.enable('biome', true)
vim.api.nvim_exec_autocmds('FileType', { buffer = buf })
assert(vim.wait(10000, function()
  local c = vim.lsp.get_clients({ bufnr = buf, name = 'biome' })[1]
  return c and c.initialized and #vim.lsp.get_clients({ bufnr = buf, name = 'eslint' }) == 1
end, 50), 'Both configured lint roles coexist')
vim.fn.delete(fixture .. '/packages/lint/biome.json')
local standalone = vim.fn.tempname() .. ' standalone'
vim.fn.mkdir(standalone .. '/.git', 'p')
for ext, lines in pairs({ lua = { 'local x={a=1}' }, py = { 'value={"x":1}' }, sh = { '#!/bin/bash', 'if true;then echo hi;fi' }, js = { 'const value={x:1}' } }) do
  local path = standalone .. '/file.' .. ext
  buf = edit(path, lines)
  assert(policy.resolve(buf).managed, 'No project policy uses managed default')
  vim.cmd.write()
  assert(not vim.deep_equal(lines, vim.fn.readfile(path)), 'Actual managed formatter ' .. ext)
end
for ext in pairs({ md = true, txt = true, log = true, zsh = true, cs = true, rs = true }) do
  local path = standalone .. '/excluded.' .. ext
  local text = ext == 'md' and { '#Heading', 'text    text' } or { 'untouched    content' }
  buf = edit(path, text)
  vim.cmd.write()
  assert(vim.deep_equal(text, vim.fn.readfile(path)), 'Excluded ' .. ext)
end
buf = edit(standalone .. '/manual.md', { '# Heading', '', '-   item' })
vim.cmd('Format')
assert(vim.api.nvim_buf_get_lines(buf, 0, -1, false)[3] == '- item', 'Markdown explicit formatting')
buf = edit(standalone .. '/opt.js', { 'const x={a:1}' })
vim.cmd('FormatDisable!')
vim.cmd.write()
assert(vim.fn.readfile(standalone .. '/opt.js')[1] == 'const x={a:1}', 'Buffer opt-out')
vim.cmd('FormatEnable')
vim.cmd('FormatDisable')
vim.cmd.write()
assert(vim.fn.readfile(standalone .. '/opt.js')[1] == 'const x={a:1}', 'Global opt-out')
vim.cmd('FormatEnable')
for _, mode in ipairs({ 'failure', 'timeout' }) do
  write(standalone .. '/.nvim-format.json', { vim.json.encode({ javascript = { formatter = 'prettier', command = { vim.fn.exepath('node'), '-e', mode == 'failure' and 'process.exit(1)' or 'setTimeout(()=>{},10000)' } } }) })
  vim.cmd.write()
  assert(vim.fn.readfile(standalone .. '/opt.js')[1] == 'const x={a:1}', 'Failure/timeout save retains edits')
end
write(standalone .. '/.nvim-format.json', { '{"javascript":{"formatter":"prettier","command":["missing"]}}' })
vim.cmd.write()
assert(vim.fn.readfile(standalone .. '/opt.js')[1] == 'const x={a:1}', 'Missing executable save')
assert(#messages >= 4, 'Actionable warnings')
vim.fn.delete(standalone .. '/.nvim-format.json')
write(standalone .. '/pyproject.toml', { '[tool.ruff]', 'line-length = 88' })
buf = edit(standalone .. '/project.py', { 'value={"x":1}' })
p, err = policy.resolve(buf)
assert(not p and err:find('Missing project'), 'Configured Python never substitutes managed Ruff')
vim.fn.mkdir(standalone .. '/.venv/bin', 'p')
assert(vim.uv.fs_symlink(require('config.tools').path('ruff'), standalone .. '/.venv/bin/ruff'))
assert(policy.resolve(buf).command[1]:gsub('^/private', '') == (standalone .. '/.venv/bin/ruff'):gsub('^/private', ''), 'Project venv Ruff')
vim.cmd.write()
assert(vim.fn.readfile(standalone .. '/project.py')[1] == 'value = {"x": 1}', 'Real project Ruff format')
vim.notify = notify
for _, c in ipairs(vim.lsp.get_clients()) do c:stop(true) end
vim.fn.delete(standalone, 'rf')
print('PASS: pinned local Prettier/Biome, monorepo/config/override/mismatch/ambiguity, format-only saves, real ESLint diagnostics/manual fixes, defaults/exclusions/manual MD/opt-outs/failure/timeout')
vim.cmd('qa!')
