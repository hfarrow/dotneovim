local function eq(expected, actual, label)
  assert(vim.deep_equal(expected, actual), label .. ': expected ' .. vim.inspect(expected) .. ', got ' .. vim.inspect(actual))
end
local function keys(input)
  vim.api.nvim_feedkeys(vim.keycode(input), 'xt', false)
end
local function lines(text)
  vim.cmd.enew({ bang = true })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, text)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end
local clipboard = { { 'outside' }, 'v' }
vim.g.clipboard = {
  name = 'test clipboard',
  copy = { ['+'] = function(value, kind) clipboard = { value, kind } end, ['*'] = function() end },
  paste = { ['+'] = function() return clipboard end, ['*'] = function() return clipboard end },
  cache_enabled = 0,
}
eq(' ', vim.g.mapleader, 'leader')
eq('', vim.o.clipboard, 'clipboard isolation')
eq(false, vim.o.autowrite, 'explicit saves')
eq(false, vim.o.autowriteall, 'explicit quit/save')
eq(vim.env.VIMRUNTIME, vim.o.packpath, 'legacy package isolation')
for _, key in ipairs({ 'd', 'c', 'x' }) do eq('', vim.fn.maparg(key, 'n'), key .. ' stays native') end
lines({ 'alpha beta gamma' })
keys('yiw')
eq('alpha', vim.fn.getreg('0'), 'last yank')
keys('wdiw')
eq('alpha', vim.fn.getreg('0'), 'delete preserves yank')
eq({ 'outside' }, clipboard[1], 'delete preserves system clipboard')
keys(' P')
assert(vim.api.nvim_get_current_line():find('alpha'), 'leader P pastes yank')
lines({ 'one two three' })
keys('"adw')
eq('one ', vim.fn.getreg('a'), 'named register delete')
keys('u2dw')
eq('three', vim.api.nvim_get_current_line(), 'counted native delete')
lines({ 'copy this' })
keys(' yiw')
eq({ 'copy' }, clipboard[1], 'clipboard operator yank')
keys('wviw p')
eq('copy copy', vim.api.nvim_get_current_line(), 'visual clipboard replacement')
eq({ 'copy' }, clipboard[1], 'visual clipboard source retained')
vim.fn.setreg('0', 'original')
lines({ 'replace' })
keys('viw P')
eq('original', vim.api.nvim_get_current_line(), 'visual last-yank paste')
eq('original', vim.fn.getreg('0'), 'last yank retained')
vim.cmd('setfiletype markdown')
eq(true, vim.wo.wrap, 'Markdown wraps')
vim.bo.filetype = 'lua'
eq(false, vim.wo.wrap, 'code stops wrapping')
vim.bo.filetype = 'text'
eq(true, vim.wo.linebreak, 'text wraps at words')
keys(' uw')
eq(false, vim.wo.wrap, 'window wrap toggle')

local file = vim.fn.tempname() .. '.txt'
vim.fn.writefile({ 'first', 'second', 'third' }, file)
vim.cmd.edit(file)
vim.api.nvim_win_set_cursor(0, { 2, 1 })
vim.fn.writefile({ 'first', 'second', 'third', 'external' }, file)
vim.api.nvim_exec_autocmds('FocusGained', {})
eq(4, vim.api.nvim_buf_line_count(0), 'external reload')
eq({ 2, 1 }, vim.api.nvim_win_get_cursor(0), 'reload view')
vim.api.nvim_buf_set_lines(0, 0, 1, false, { 'unsaved' })
vim.api.nvim_exec_autocmds('FocusLost', {})
eq('first', vim.fn.readfile(file)[1], 'focus loss does not write')
vim.fn.writefile({ 'new external' }, file)
vim.api.nvim_exec_autocmds('FocusGained', {})
eq('unsaved', vim.api.nvim_buf_get_lines(0, 0, 1, false)[1], 'unsaved reload protection')
vim.cmd('write!')
vim.cmd('wundo ' .. vim.fn.fnameescape(file .. '.undo'))
eq(1, vim.fn.filereadable(file .. '.undo'), 'persistent undo written')
vim.api.nvim_buf_set_mark(0, '"', 2, 1, {})
vim.api.nvim_exec_autocmds('BufReadPost', { buffer = 0 })
eq({ 2, 1 }, vim.api.nvim_win_get_cursor(0), 'cursor restored')
vim.fn.delete(file)
vim.fn.delete(file .. '.undo')

if vim.g.colors_name == 'gruvbox-material' then
  for mode, expected in pairs({ dark = { '#282828', '#d4be98' }, light = { '#fbf1c7', '#654735' } }) do
    vim.cmd('Appearance ' .. mode)
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    eq(expected[1], string.format('#%06x', normal.bg), mode .. ' background')
    eq(expected[2], string.format('#%06x', normal.fg), mode .. ' foreground')
  end
end
for _, path in ipairs(vim.fn.glob(vim.g.dotneovim_root .. '/lua/**/*.lua', false, true)) do
  assert(loadfile(path), 'Lua compilation: ' .. path)
end
print('PASS: core registers, clipboard, save/reload, wrapping, state and theme checks')
vim.cmd('qa!')
