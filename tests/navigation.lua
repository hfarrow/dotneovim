local search = require('config.search')
local fixture = vim.fn.tempname() .. ' search space'
vim.fn.mkdir(fixture .. '/nested', 'p')
vim.fn.mkdir(fixture .. '/.git', 'p')
for _, file in ipairs({ 'normal.txt', '.hidden.txt', 'ignored.txt', '.git/secret', 'nested/child.txt' }) do
  vim.fn.writefile({ 'needle ' .. file }, fixture .. '/' .. file)
end
vim.fn.writefile({ 'ignored.txt' }, fixture .. '/.gitignore')
local expected = { normal = 2, hidden = 3, all = 4 }
for _, kind in ipairs({ 'files', 'grep' }) do
  for mode, count in pairs(expected) do
    local args = search.argv(kind, mode)
    if kind == 'grep' then args[#args + 1] = 'needle' end
    local result = vim.system(args, { cwd = fixture, text = true }):wait(3000)
    assert(result.code == 0, result.stderr)
    local values = vim.split(vim.trim(result.stdout), '\n')
    if kind == 'files' and mode ~= 'normal' then count = count + 1 end -- .gitignore
    assert(#values == count, kind .. '/' .. mode .. ': ' .. result.stdout)
    assert(not result.stdout:find('secret'))
  end
end
assert(require('config.project').root(fixture .. '/nested') == fixture)
vim.fn.writefile({ 'gitdir: elsewhere' }, fixture .. '/nested/.git')
assert(require('config.project').root(fixture .. '/nested') == fixture .. '/nested', 'Worktree .git file')
vim.fn.delete(fixture .. '/nested/.git')
vim.cmd.cd(fixture .. '/nested')
local cwd = vim.fn.getcwd()
for _, mode in ipairs({ 'normal', 'hidden', 'all' }) do
  for _, scope in ipairs({ 'directory', 'project' }) do
    search.open('files', mode, scope)
    local buf = vim.api.nvim_get_current_buf()
    local picker = require('telescope.actions.state').get_current_picker(buf)
    local count = scope == 'directory' and 1 or expected[mode] + (mode == 'normal' and 0 or 1)
    assert(vim.wait(3000, function() return picker.manager and picker.manager:num_results() == count end, 20), 'Real picker result count ' .. mode .. '/' .. scope)
    assert(vim.fn.getcwd() == cwd)
    require('telescope.actions').close(buf)
  end
end
for mode, count in pairs(expected) do
  for _, scope in ipairs({ 'directory', 'project' }) do
    search.open('grep', mode, scope, nil, 'needle')
    local prompt = vim.api.nvim_get_current_buf()
    local p = require('telescope.actions.state').get_current_picker(prompt)
    assert(vim.wait(3000, function() return p.manager and p.manager:num_results() == (scope == 'directory' and 1 or count) end, 20), 'Grep matrix')
    assert(vim.fn.getcwd() == cwd)
    require('telescope.actions').close(prompt)
  end
end
search.open('files', 'normal', 'project', { directory = vim.fn.stdpath('cache') })
buf = vim.api.nvim_get_current_buf()
assert(require('telescope.actions.state').get_current_picker(buf).prompt_title:find('fallback'))
require('telescope.actions').close(buf)
search.open('grep', 'all', 'project', nil, 'needle')
local buf = vim.api.nvim_get_current_buf()
local picker = require('telescope.actions.state').get_current_picker(buf)
assert(vim.wait(3000, function() return picker.manager and picker.manager:num_results() == 4 end, 20), 'Real grep results')
require('telescope.actions').send_to_qflist(buf)
assert(#vim.fn.getqflist() == 4, 'Quickfix handoff')
for _, kind in ipairs({ 'buffers', 'oldfiles', 'current_buffer_fuzzy_find' }) do
  require('telescope.builtin')[kind]()
  assert(vim.bo.filetype == 'TelescopePrompt')
  require('telescope.actions').close(vim.api.nvim_get_current_buf())
end
vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(fixture))
local api = require('nvim-tree.api')
assert(vim.bo.filetype == 'NvimTree')
local origin_input, origin_select = vim.ui.input, vim.ui.select
vim.ui.input = function(_, cb) cb(fixture .. '/created.txt') end
api.fs.create()
assert(vim.wait(2000, function() return vim.fn.filereadable(fixture .. '/created.txt') == 1 end))
local function node(path)
  api.tree.reload()
  local found
  assert(vim.wait(2000, function()
    local function walk(n)
      if vim.uv.fs_realpath(n.absolute_path) == vim.uv.fs_realpath(path) then found = n end
      for _, c in ipairs(n.nodes or {}) do walk(c) end
    end
    local nodes = api.tree.get_nodes()
    if nodes.absolute_path then walk(nodes) else for _, n in ipairs(nodes) do walk(n) end end
    return found ~= nil
  end), 'Tree node ' .. path)
  api.tree.find_file({ buf = path, focus = true })
  return api.tree.get_node_under_cursor()
end
vim.ui.input = function(_, cb) cb('renamed.txt') end
api.fs.rename(node(fixture .. '/created.txt'))
assert(vim.fn.filereadable(fixture .. '/renamed.txt') == 1)
api.fs.copy.node(node(fixture .. '/renamed.txt'))
api.fs.paste(node(fixture .. '/nested'))
assert(vim.wait(2000, function() return vim.fn.filereadable(fixture .. '/nested/renamed.txt') == 1 end))
-- Move to a non-conflicting destination, then full-path rename.
vim.fn.mkdir(fixture .. '/destination', 'p')
api.fs.cut(node(fixture .. '/renamed.txt'))
api.fs.paste(node(fixture .. '/destination'))
assert(vim.wait(2000, function() return vim.fn.filereadable(fixture .. '/destination/renamed.txt') == 1 end))
vim.ui.input = function(_, cb) cb(fixture .. '/nested/moved.txt') end
api.fs.rename_full(node(fixture .. '/destination/renamed.txt'))
assert(vim.wait(2000, function() return vim.fn.filereadable(fixture .. '/nested/moved.txt') == 1 end))
vim.ui.select = function(items, _, cb)
  for i, item in ipairs(items) do if tostring(item):lower():find('yes') then cb(item, i); return end end
  cb(items[1], 1)
end
vim.ui.input = function(_, cb) cb('y') end
api.fs.remove(node(fixture .. '/nested'))
assert(vim.wait(2000, function() return vim.fn.isdirectory(fixture .. '/nested') == 0 end))
vim.ui.input, vim.ui.select = origin_input, origin_select
api.tree.close()
assert(vim.bo.filetype ~= 'NvimTree')
vim.fn.delete(fixture, 'rf')
print('PASS: real rg/Telescope matrices, root/worktree/cwd, quickfix/pickers, tree create/rename/copy/move/delete/focus')
vim.cmd('qa!')
