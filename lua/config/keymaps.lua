local map = vim.keymap.set
vim.api.nvim_create_user_command('SetupHealth', function() vim.cmd('checkhealth dotneovim') end,
  { desc = 'Check locked plugins, parsers, tools and setup prerequisites' })
vim.api.nvim_create_user_command('ToolHealth', function()
  local tools, report = require('config.tools'), {}
  for name, version in pairs(tools.manifest) do
    local executable = tools.executable(name)
    report[#report + 1] = name .. '@' .. version .. ': ' .. (tools.available(executable) and tools.path(executable) or 'MISSING: nvim -l scripts/tools.lua')
  end
  vim.notify(table.concat(report, '\n'))
end, { desc = 'Show managed tool paths and provisioning requirements' })
vim.diagnostic.config({ virtual_text = false, virtual_lines = false, signs = true, underline = true, update_in_insert = false, severity_sort = true })
map('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
map('n', '<leader>dd', '<cmd>Telescope diagnostics<cr>', { desc = 'Diagnostic picker' })
local function bind(mode, lhs, rhs, desc)
  map(mode, lhs, rhs, { silent = true, desc = desc })
end

for _, chord in ipairs({ 'jj', 'jk', 'kj' }) do
  bind('i', chord, '<Esc>', 'Leave insert mode')
end
bind('n', 'n', 'nzz', 'Next search match, centered')
bind('n', 'N', 'Nzz', 'Previous search match, centered')
bind({ 'n', 'x' }, 'H', '^', 'First nonblank character')
bind('n', 'L', '$', 'End of line')
bind('x', 'L', 'g_', 'Last nonblank character')
bind('x', '<', '<gv', 'Indent left and reselect')
bind('x', '>', '>gv', 'Indent right and reselect')
for _, direction in ipairs({ 'h', 'j', 'k', 'l' }) do
  bind('n', '<C-' .. direction .. '>', '<C-w>' .. direction, 'Focus split ' .. direction)
end
bind({ 'n', 'x' }, '<leader>y', '"+y', 'Yank to system clipboard')
bind('n', '<leader>p', '"+p', 'Paste system clipboard')
bind('x', '<leader>p', '"+P', 'Replace with clipboard, retain source')
bind('n', '<leader>P', '"0p', 'Paste last Vim yank')
bind('x', '<leader>P', '"0P', 'Replace with last yank, retain source')
bind('n', '<leader><CR>', '<cmd>nohlsearch<CR>', 'Clear search highlighting')
bind('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
  vim.w.dotneovim_wrap = vim.wo.wrap
end, 'Toggle soft wrap in this window')
bind('n', '<leader>un', function() vim.wo.number = not vim.wo.number end, 'Toggle line numbers')
bind('n', '<leader>ur', function() vim.wo.relativenumber = not vim.wo.relativenumber end, 'Toggle relative numbers')
bind('n', '<leader>uc', function() vim.wo.cursorline = not vim.wo.cursorline end, 'Toggle cursor line')

vim.api.nvim_create_user_command('Appearance', function(args)
  vim.o.background = args.args
end, {
  nargs = 1,
  complete = function() return { 'dark', 'light' } end,
  desc = 'Select theme variant manually when terminal detection is unavailable',
})
