local M = { timeout = 1500 }
local auto = { lua = true, python = true, sh = true, bash = true, javascript = true, javascriptreact = true, typescript = true, typescriptreact = true }
function M.run(buf, manual)
  if vim.bo[buf].buftype ~= '' or require('config.largefile').check(buf) then return end
  if not manual and (not auto[vim.bo[buf].filetype] or vim.g.disable_autoformat or vim.b[buf].disable_autoformat) then return end
  local policy, err = require('config.format_policy').resolve(buf)
  if not policy then if err then vim.notify(err .. '; saving without formatting', vim.log.levels.WARN) end; return end
  local name = vim.api.nvim_buf_get_name(buf)
  local args = vim.list_slice(policy.command, 2)
  local tool_args = {
    prettier = { '--stdin-filepath', name }, biome = { 'format', '--stdin-file-path', name },
    stylua = { '--stdin-filepath', name, '-' }, shfmt = { '-filename', name },
    ruff = { 'format', '--stdin-filename', name, '-' }, black = { '--stdin-filename', name, '-' },
  }
  vim.list_extend(args, tool_args[policy.tool])
  require('conform').formatters.dotneovim = { command = policy.command[1], args = args, stdin = true, cwd = function() return policy.cwd end }
  require('conform').format({ bufnr = buf, formatters = { 'dotneovim' }, timeout_ms = M.timeout, lsp_format = 'never', async = false }, function(failure)
    if failure then vim.notify('Formatting failed; saving edits unchanged: ' .. failure, vim.log.levels.WARN) end
  end)
end
function M.setup()
  require('conform').setup({ notify_on_error = false, notify_no_formatters = false })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('dotneovim.format', { clear = true }), callback = function(ev)
      local ok, err = pcall(M.run, ev.buf, false)
      if not ok then vim.notify('Formatting unavailable; saving edits unchanged: ' .. err, vim.log.levels.WARN) end
    end,
  })
  vim.api.nvim_create_user_command('Format', function() M.run(vim.api.nvim_get_current_buf(), true) end, { desc = 'Explicit project format-only operation' })
  vim.api.nvim_create_user_command('FormatDisable', function(cmd) if cmd.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end end, { bang = true })
  vim.api.nvim_create_user_command('FormatEnable', function() vim.b.disable_autoformat = false; vim.g.disable_autoformat = false end, {})
end
return M
