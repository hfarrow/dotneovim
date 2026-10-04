local M = {}
local modes = { 'normal', 'hidden', 'all' }

function M.argv(kind, visibility)
  local args = kind == 'files' and { 'rg', '--files' }
    or { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
  if visibility ~= 'normal' then args[#args + 1] = '--hidden' end
  if visibility == 'all' then args[#args + 1] = '--no-ignore' end
  vim.list_extend(args, { '--glob', '!.git/**', '--glob', '!**/.git/**' })
  return args
end

function M.open(kind, visibility, scope, context, prompt)
  if vim.fn.executable('rg') ~= 1 then vim.notify('Search requires ripgrep (rg)', vim.log.levels.WARN); return end
  visibility, scope = visibility or 'normal', scope or 'directory'
  context = context or { directory = require('config.project').directory() }
  context.root = context.root or require('config.project').root(context.directory)
  local cwd = scope == 'project' and context.root or context.directory
  cwd = cwd or context.directory
  local title = kind .. ' · ' .. visibility .. ' · ' .. scope
  if scope == 'project' and not context.root then title = title .. ' (directory fallback)' end
  local opts = {
    cwd = cwd, prompt_title = title, default_text = prompt,
    attach_mappings = function(buf, map)
      local actions = require('telescope.actions')
      local function reopen(next_mode, next_scope)
        local text = require('telescope.actions.state').get_current_line()
        actions.close(buf)
        vim.schedule(function() M.open(kind, next_mode, next_scope, context, text) end)
      end
      for _, mode in ipairs({ 'i', 'n' }) do
        map(mode, '<C-v>', function()
          local index = vim.fn.index(modes, visibility) + 1
          reopen(modes[index % 3 + 1], scope)
        end)
        map(mode, '<C-r>', function() reopen(visibility, scope == 'directory' and 'project' or 'directory') end)
      end
      return true
    end,
  }
  if kind == 'files' then
    opts.find_command = M.argv(kind, visibility)
    require('telescope.builtin').find_files(opts)
  else
    opts.vimgrep_arguments = M.argv(kind, visibility)
    require('telescope.builtin').live_grep(opts)
  end
end

function M.setup()
  vim.api.nvim_create_user_command('Search', function(cmd)
    M.open(cmd.fargs[1] or 'files', cmd.fargs[2] or 'normal', cmd.fargs[3] or 'directory')
  end, { nargs = '*', desc = 'Search files|grep normal|hidden|all directory|project' })
end
return M
