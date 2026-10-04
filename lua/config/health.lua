local M = {}
local function json(path)
  local ok, data = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(path), '\n')) end)
  return ok and data or nil
end
function M.report()
  local report = {}
  local function add(ok, name, detail, remedy, optional)
    report[#report + 1] = { ok = ok, name = name, detail = detail, remedy = remedy, optional = optional }
  end
  local root, data = vim.g.dotneovim_root, vim.fn.stdpath('data')
  local command = function(script) return 'nvim -l ' .. vim.fs.joinpath(root, 'scripts', script .. '.lua') end
  add(vim.fn.has('nvim-0.12.5') == 1, 'Neovim', tostring(vim.version()), 'Install Neovim >=0.12.5')
  for _, name in ipairs({ 'git', 'rg', 'node', 'npm', 'lazygit' }) do
    local path = vim.fn.exepath(name)
    add(path ~= '', name, path, 'Install ' .. name .. ' and put it on PATH; see docs/setup.md')
  end
  local python = vim.fn.exepath('python3')
  if python == '' then python = vim.fn.exepath('python') end
  add(python ~= '', 'Python runtime', python, 'Install Python >=3.10 on PATH')
  local node = vim.fn.exepath('node')
  if node ~= '' then
    local result = vim.system({ node, '--version' }, { text = true }):wait(2000)
    local major, minor, patch = (result.stdout or ''):match('v(%d+)%.(%d+)%.(%d+)')
    local ok = major and (tonumber(major) > 22 or tonumber(major) == 22 and (tonumber(minor) > 22 or tonumber(minor) == 22 and tonumber(patch) >= 2))
    add(ok == true, 'Node version', vim.trim(result.stdout or ''), 'Install Node >=22.22.2')
  end
  if python ~= '' then
    local result = vim.system({ python, '--version' }, { text = true }):wait(2000)
    local major, minor = (result.stdout or ''):match('Python (%d+)%.(%d+)')
    add(result.code == 0 and major ~= nil and (tonumber(major) > 3 or tonumber(major) == 3 and tonumber(minor) >= 10),
      'Python version', vim.trim(result.stdout or ''), 'Install Python >=3.10')
  end
  local shell = vim.o.shell
  add(vim.fn.executable(shell) == 1, 'Shell', shell, 'Set shell to an installed shell; see docs/setup.md')
  local lock = json(vim.fs.joinpath(root, 'lazy-lock.json')) or {}
  for _, name in ipairs(vim.tbl_keys(lock)) do
    local path = vim.fs.joinpath(data, 'lazy', name)
    local result = vim.fn.executable('git') == 1 and vim.system({ 'git', '-C', path, 'rev-parse', 'HEAD' }, { text = true }):wait(2000) or {}
    local revision = vim.trim(result.stdout or '')
    add(result.code == 0 and revision == lock[name].commit, 'Plugin ' .. name, revision ~= '' and revision or 'MISSING', command('install'))
  end
  for _, lang in ipairs(require('config.reading').parsers) do
    local loaded = pcall(vim.treesitter.language.add, lang)
    local ok, query = pcall(vim.treesitter.query.get, lang, 'highlights')
    add(loaded and ok and query ~= nil, 'Parser ' .. lang, loaded and 'platform parser loaded' or 'MISSING', command('parsers'))
  end
  if vim.env.DOTNEOVIM_BLINK_LUA == '1' then
    add(true, 'Blink matcher', 'Explicit Lua fallback', command('install'))
  else
    local matcher = pcall(require, 'blink.cmp.fuzzy.rust')
    local receipt = vim.fs.joinpath(data, 'lazy', 'blink.cmp', 'target', 'release', 'version')
    local ok, lines = pcall(vim.fn.readfile, receipt)
    add(matcher and ok and lines[1] == (lock['blink.cmp'] or {}).commit, 'Blink matcher',
      matcher and 'Native library loaded; locked commit receipt' or 'MISSING', command('install'))
  end
  local tools = require('config.tools')
  for name, version in pairs(tools.manifest) do
    local receipt = json(vim.fs.joinpath(data, 'mason', 'packages', name, 'mason-receipt.json'))
    local id = receipt and receipt.source and receipt.source.id or ''
    local path = tools.path(tools.executable(name))
    add(id:sub(-#version - 1) == '@' .. version and vim.fn.executable(path) == 1,
      'Tool ' .. name .. '@' .. version, path .. ' [' .. id .. ']', command('tools'))
  end
  local provider = vim.fn['provider#clipboard#Executable']()
  add(provider ~= '', 'Clipboard provider', provider, 'Install/configure a native clipboard provider; see docs/setup.md')
  for _, name in ipairs({ 'tree-sitter', 'cc', 'curl', 'tar' }) do
    local path = vim.fn.exepath(name)
    add(path ~= '', 'Build prerequisite ' .. name, path, 'Needed only for explicit parser builds; see docs/setup.md', true)
  end
  table.sort(report, function(a, b) return a.name < b.name end)
  return report
end
function M.check()
  vim.health.start('dotneovim setup (local checks, no provisioning)')
  for _, item in ipairs(M.report()) do
    local message = item.name .. ': ' .. item.detail
    if item.ok then vim.health.ok(message)
    elseif item.optional then vim.health.warn(message, { item.remedy })
    else vim.health.error(message, { item.remedy }) end
  end
  vim.health.info('Windows/WSL are portability-reviewed, not runtime-tested. Nerd Font presentation and live host appearance need attached terminal acceptance.')
end
return M
