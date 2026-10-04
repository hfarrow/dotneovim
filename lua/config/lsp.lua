local M = {}
local tools = require('config.tools')
function M.python(root)
  for _, dir in ipairs({ '.venv', 'venv' }) do
    local path = tools.venv_executable(vim.fs.joinpath(root, dir), 'python')
    if vim.fn.executable(path) == 1 then return path end
  end
  if vim.env.VIRTUAL_ENV then
    local path = tools.venv_executable(vim.env.VIRTUAL_ENV, 'python')
    if vim.fn.executable(path) == 1 then return path end
  end
  local python = vim.fn.exepath('python3')
  return python ~= '' and python or vim.fn.exepath('python')
end
local function root(buf, on_dir)
  if vim.api.nvim_buf_get_name(buf) == '' or require('config.largefile').check(buf) then return end
  on_dir(require('config.project').root(require('config.project').directory(buf)) or require('config.project').directory(buf))
end
function M.tsserver(dir)
  for parent in vim.fs.parents(vim.fs.joinpath(dir, '_')) do
    local path = vim.fs.joinpath(parent, 'node_modules', 'typescript', 'lib', 'tsserver.js')
    if vim.uv.fs_stat(path) then return path end
    local manifest = vim.fs.joinpath(parent, 'package.json')
    if vim.uv.fs_stat(manifest) then
      local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(manifest), '\n'))
      if ok and ((data.dependencies or {}).typescript or (data.devDependencies or {}).typescript) then
        return nil, 'Project TypeScript missing/incompatible (ts_ls requires TypeScript <7). Install the pinned project compiler.'
      end
    end
    if vim.uv.fs_stat(vim.fs.joinpath(parent, '.git')) then break end
  end
  return vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'typescript-language-server', 'node_modules', 'typescript', 'lib', 'tsserver.js')
end
function M.setup()
  vim.diagnostic.config({ virtual_text = false, virtual_lines = false, signs = true, underline = true, update_in_insert = false, severity_sort = true })
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  vim.lsp.config('*', { capabilities = capabilities, root_dir = root })
  local definitions = {
    bashls = { tool = 'bash-language-server', args = { 'start' }, settings = { bashIde = {
      shellcheckPath = tools.path('shellcheck'), shfmtPath = '', globPattern = '*@(.sh|.bash)',
    } } },
    ts_ls = { tool = 'typescript-language-server', args = { '--stdio' },
      root_dir = function(buf, cb)
        if vim.api.nvim_buf_get_name(buf) == '' or require('config.largefile').check(buf) then return end
        local dir = require('config.project').directory(buf)
        local compiler, err = M.tsserver(dir)
        if err then vim.notify(err, vim.log.levels.WARN); return end
        if compiler then cb(require('config.project').root(dir) or dir) end
      end,
      before_init = function(_, config)
        config.init_options = vim.tbl_deep_extend('force', config.init_options or {}, { tsserver = { path = M.tsserver(config.root_dir) } })
      end },
    lua_ls = { tool = 'lua-language-server', settings = { Lua = {
      runtime = { version = 'LuaJIT' }, diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME .. '/lua' } }, telemetry = { enable = false },
    } } },
    pyright = { tool = 'pyright-langserver', args = { '--stdio' },
      before_init = function(_, config) config.settings.python.pythonPath = M.python(config.root_dir) end,
      settings = { python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly', diagnosticSeverityOverrides = { reportUnusedImport = 'none', reportUnusedVariable = 'none' } } } } },
    ruff = { tool = 'ruff', args = { 'server' }, on_attach = function(client) client.server_capabilities.hoverProvider = false end },
  }
  for name, definition in pairs(definitions) do
    local tool, args = definition.tool, definition.args or {}
    definition.tool, definition.args = nil, nil
    definition.cmd = vim.list_extend({ tools.path(tool) }, args)
    definition.root_dir = definition.root_dir or root
    -- Conform will be the only formatting owner; servers expose explicit code actions.
    local attach = definition.on_attach
    definition.on_attach = function(client, buf)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      if attach then attach(client, buf) end
    end
    vim.lsp.config(name, definition)
    if tools.available(tool) then vim.lsp.enable(name) end
  end
  vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
  vim.keymap.set('n', '<leader>dd', '<cmd>Telescope diagnostics<cr>', { desc = 'Diagnostic picker' })
  vim.api.nvim_create_user_command('ToolHealth', function()
    local report = {}
    for name, version in pairs(tools.manifest) do
      local executable = tools.executable(name)
      report[#report + 1] = name .. '@' .. version .. ': ' .. (tools.available(executable) and tools.path(executable) or 'MISSING: nvim -l scripts/tools.lua')
    end
    vim.notify(table.concat(report, '\n'))
  end, { desc = 'Show managed tool paths and provisioning requirements' })
end
return M
