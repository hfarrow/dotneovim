local M = {}
function M.setup()
  local policy = require('config.format_policy')
  local function root(tool)
    return function(buf, cb)
      if require('config.largefile').check(buf) then return end
      local config, err = policy.lint(tool, buf)
      if config then cb(config.root) elseif err then vim.notify(err, vim.log.levels.WARN) end
    end
  end
  local base = vim.lsp.config.eslint.on_attach
  vim.lsp.config('eslint', {
    cmd = { require('config.tools').path('vscode-eslint-language-server'), '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = root('eslint'),
    settings = { format = false, codeActionOnSave = { enable = false }, workingDirectory = { mode = 'auto' } },
    on_attach = function(client, buf)
      client.server_capabilities.documentFormattingProvider = false
      if base then base(client, buf) end
    end,
  })
  if require('config.tools').available('vscode-eslint-language-server') then vim.lsp.enable('eslint') end
  vim.lsp.config('biome', {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, root_dir = root('biome'),
    cmd = function(dispatchers, config)
      local command = assert(policy.local_tool('biome', policy.ancestors(config.root_dir)))
      return vim.lsp.rpc.start({ command, 'lsp-proxy' }, dispatchers, { cwd = config.root_dir })
    end,
    on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
  })
  vim.lsp.enable('biome')
end
return M
