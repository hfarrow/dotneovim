local M = {}
local packages = { prettier = 'prettier', biome = '@biomejs/biome', eslint = 'eslint' }
local defaults = { lua = 'stylua', python = 'ruff', sh = 'shfmt', bash = 'shfmt', javascript = 'prettier', javascriptreact = 'prettier', typescript = 'prettier', typescriptreact = 'prettier', markdown = 'prettier' }
local configs = {
  prettier = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.cjs', '.prettierrc.yaml', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs', 'prettier.config.mjs' },
  biome = { 'biome.json', 'biome.jsonc' },
  eslint = { '.eslintrc', '.eslintrc.json', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yml', '.eslintrc.yaml', 'eslint.config.js', 'eslint.config.cjs', 'eslint.config.mjs', 'eslint.config.ts' },
  stylua = { 'stylua.toml', '.stylua.toml' }, shfmt = { '.shfmt' },
}
function M.ancestors(dir)
  local result = {}
  for _ = 1, 64 do
    result[#result + 1] = dir
    if vim.uv.fs_stat(dir .. '/.git') or dir == vim.uv.os_homedir() then break end
    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then break end
    dir = parent
  end
  return result
end
local function json(path)
  if not vim.uv.fs_stat(path) then return nil end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
  return ok and data or nil
end
local function any(dir, names)
  for _, name in ipairs(names or {}) do if vim.uv.fs_stat(dir .. '/' .. name) then return true end end
  return false
end
local function version_ok(command, expected)
  local args = vim.deepcopy(command)
  args[#args + 1] = '--version'
  local result = vim.system(args, { text = true }):wait(1000)
  local actual = (result.stdout or ''):match('%d+%.%d+%.%d+')
  return result.code == 0 and actual == expected:gsub('^v', '')
end
function M.local_tool(tool, dirs, declared)
  for _, dir in ipairs(dirs) do
    local path = vim.fs.joinpath(dir, 'node_modules', '.bin', tool .. (vim.fn.has('win32') == 1 and '.cmd' or ''))
    local metadata = packages[tool] and json(vim.fs.joinpath(dir, 'node_modules', packages[tool], 'package.json'))
    if vim.fn.executable(path) == 1 and metadata then
      if not declared and not any(dir, { 'package-lock.json', 'pnpm-lock.yaml', 'yarn.lock', 'bun.lock', 'bun.lockb' }) then
        return nil, 'Project ' .. tool .. ' must have an explicit version or lockfile'
      end
      if declared and declared:match('^%d+%.%d+%.%d+$') and metadata.version ~= declared then
        return nil, 'Installed ' .. tool .. ' ' .. metadata.version .. ' differs from required ' .. declared
      end
      if declared and not declared:match('^%d+%.%d+%.%d+$') and not any(dir, { 'package-lock.json', 'pnpm-lock.yaml', 'yarn.lock', 'bun.lock', 'bun.lockb' }) then
        return nil, 'Pin ' .. tool .. ' with a project lockfile or exact version'
      end
      local lock = json(dir .. '/package-lock.json')
      local pinned = lock and lock.packages and lock.packages['node_modules/' .. packages[tool]]
      if pinned and pinned.version ~= metadata.version then return nil, 'Installed ' .. tool .. ' differs from the project lock; restore dependencies' end
      return path, nil, metadata.version
    end
    if not packages[tool] then
      for _, candidate in ipairs({ dir .. '/.venv/bin/' .. tool, dir .. '/venv/bin/' .. tool,
        dir .. '/.venv/Scripts/' .. tool .. '.exe', dir .. '/bin/' .. tool }) do
        if vim.fn.executable(candidate) == 1 then
          if declared then
            if not version_ok({ candidate }, declared) then return nil, 'Project ' .. tool .. ' version mismatch: expected ' .. declared end
          end
          return candidate
        end
      end
    end
  end
  return nil, 'Missing project ' .. tool .. ': install its pinned local dependency (no managed substitution)'
end
function M.resolve(buf)
  local ft = vim.bo[buf].filetype
  if not defaults[ft] then return nil end
  local dirs = M.ancestors(require('config.project').directory(buf))
  local override, chosen, policy_dir, declared
  for _, dir in ipairs(dirs) do
    local data = json(dir .. '/.nvim-format.json')
    if vim.uv.fs_stat(dir .. '/.nvim-format.json') and not data then return nil, 'Invalid .nvim-format.json; fix project policy' end
    if data and data[ft] then override, policy_dir = data[ft], dir; break end
  end
  if override then
    if override.formatter == false then return nil end
    chosen, declared = override.formatter, override.version
    if not vim.tbl_contains({ 'prettier', 'biome', 'stylua', 'shfmt', 'ruff', 'black' }, chosen) then return nil, 'Unsupported override formatter' end
    if override.command then
      local command = vim.deepcopy(override.command)
      if type(command) ~= 'table' or #command == 0 then return nil, 'Override command must be an argv array' end
      local absolute = command[1]:match('^/') or command[1]:match('^%a:[/\\]') or command[1]:match('^\\\\')
      command[1] = absolute and command[1] or vim.fs.joinpath(policy_dir, command[1])
      if vim.fn.executable(command[1]) ~= 1 then return nil, 'Missing override executable: ' .. command[1] end
      if declared and not version_ok(command, declared) then return nil, 'Override version mismatch: expected ' .. declared end
      return { tool = chosen, command = command, cwd = policy_dir, version = declared }
    end
  elseif ft:find('javascript') or ft:find('typescript') or ft == 'markdown' then
    for _, dir in ipairs(dirs) do
      local package = json(dir .. '/package.json') or {}
      local deps = vim.tbl_extend('force', package.dependencies or {}, package.devDependencies or {})
      local biome = any(dir, configs.biome) or deps['@biomejs/biome']
      local prettier = any(dir, configs.prettier) or package.prettier or deps.prettier
      if biome and prettier then return nil, 'Ambiguous Biome/Prettier policy: declare .nvim-format.json owner' end
      if biome or prettier then chosen, policy_dir = biome and 'biome' or 'prettier', dir; declared = deps[packages[chosen]]; break end
      if any(dir, configs.eslint) or package.eslintConfig or deps.eslint then return nil end
    end
  elseif ft == 'python' then
    for _, dir in ipairs(dirs) do
      local path = dir .. '/pyproject.toml'
      local content = vim.uv.fs_stat(path) and table.concat(vim.fn.readfile(path), '\n') or ''
      local ruff, black = content:find('%[tool%.ruff'), content:find('%[tool%.black')
      if ruff and black then return nil, 'Ambiguous Ruff/Black: declare .nvim-format.json owner' end
      if ruff or black or any(dir, { 'ruff.toml', '.ruff.toml' }) then
        chosen, policy_dir = black and 'black' or 'ruff', dir
        declared = content:match(chosen .. '%s*==%s*([%d%.]+)')
        break
      end
    end
  else
    for _, dir in ipairs(dirs) do if any(dir, configs[defaults[ft]]) then chosen, policy_dir = defaults[ft], dir; break end end
  end
  if chosen then
    local path, err, version = M.local_tool(chosen, dirs, declared)
    if not path then return nil, err end
    return { tool = chosen, command = { path }, cwd = policy_dir, version = version }
  end
  chosen = defaults[ft]
  local path = require('config.tools').path(chosen)
  if vim.fn.executable(path) ~= 1 then return nil, 'Missing managed ' .. chosen .. ': run nvim -l scripts/tools.lua' end
  return { tool = chosen, command = { path }, cwd = dirs[1], managed = true }
end
function M.lint(tool, buf)
  local dirs = M.ancestors(require('config.project').directory(buf))
  for _, dir in ipairs(dirs) do
    local package = json(dir .. '/package.json') or {}
    if any(dir, configs[tool]) or (tool == 'eslint' and package.eslintConfig) then
      local deps = vim.tbl_extend('force', package.dependencies or {}, package.devDependencies or {})
      local path, err = M.local_tool(tool, dirs, deps[packages[tool]])
      return path and { command = path, root = dir } or nil, err
    end
  end
end
return M
