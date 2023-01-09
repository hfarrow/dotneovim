local M = {
  bind = vim.keymap.set,
  bind_opt = {
    remap = { remap = true },
    silent = { silent = true },
    expr = { expr = true },
  },
  nbind = function(lhs, rhs, opts)
    vim.keymap.set('n', lhs, rhs, opts)
  end,
  vbind = function(lhs, rhs, opts) vim.keymap.set('v', lhs, rhs, opts) end,
  ibind = function(lhs, rhs, opts) vim.keymap.set('i', lhs, rhs, opts) end,
  xbind = function(lhs, rhs, opts) vim.keymap.set('x', lhs, rhs, opts) end,
  tbind = function(lhs, rhs, opts) vim.keymap.set('t', lhs, rhs, opts) end,
  itbind = function(lhs, rhs, opts) vim.keymap.set({ 'i', 't' }, lhs, rhs, opts) end,
  nxbind = function(lhs, rhs, opts) vim.keymap.set({ 'n', 'x' }, lhs, rhs, opts) end,
  tunbind = function(lhs, opts) vim.keymap.del('t', lhs, opts) end,
}

function M.get_dotneovim_path(file)
  -- TODO: make this detect the path in a reliable and automatic way
  local path = "~/.config/dotneovim/"
  if file ~= nil then path = path .. file end
  return path
end

function M.toggle_opt(prop, scope, on, off)
  if on == nil then
    on = true
  end

  if off == nil then
    off = false
  end

  if scope == nil then
    scope = 'o'
  end

  return function()
    if vim[scope][prop] == on then
      vim[scope][prop] = off
    else
      vim[scope][prop] = on
    end
  end
end

function M.autocmd_helper(augroup, opts)
  if type(augroup) == 'string' then
    augroup = vim.api.nvim_create_augroup(augroup, opts)
  end
  return function(events, autocmd_opts)
    if type(events) ~= 'table' then
      events = { events }
    end
    if (autocmd_opts.pattern == nil) then
      autocmd_opts.pattern = '*'
    end
    vim.api.nvim_create_autocmd(events, {
      group = augroup,
      desc = autocmd_opts.desc,
      pattern = autocmd_opts.pattern,
      command = autocmd_opts.command,
      callback = autocmd_opts.callback
    })
  end
end

function M.blog_pick_img()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local previewers = require "telescope.previewers"
  local post_name, _ = vim.fn.expand('%:t:r')
  local post_dir = vim.fn.expand('%:p:h')
  local post_content_dir = post_dir .. '/../../static/posts/' .. post_name .. '/'

  local opts = {
    prompt_title = 'Select Image',
    cwd = post_content_dir,
    layout_config = {
      width = 0.99,
      height = 0.99,
      horizontal = {
        preview_width = 0.8
      },
    },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local markdown = '![](' .. selection[1] .. ')'
        vim.api.nvim_put({ markdown }, "", false, true)
      end)
      return true
    end,
    previewer = previewers.new_termopen_previewer({
      title = 'Image Preview (Viu)',
      get_command = function(entry, _)
        return { 'viu', entry.path }
      end
    }),
  }

  require('telescope.builtin').find_files(opts)
end

return M
