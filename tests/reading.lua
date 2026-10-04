local function keys(s) vim.api.nvim_feedkeys(vim.keycode(s), 'xt', false) end
local function buffer(ft, lines)
  vim.cmd.enew({ bang = true })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.filetype = ft
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end
for _, lang in ipairs(require('config.reading').parsers) do
  assert(pcall(vim.treesitter.language.add, lang), lang)
  assert(vim.treesitter.query.get(lang, 'highlights'), lang .. ' highlighting query')
  local parser = vim.treesitter.get_string_parser('', lang)
  assert(parser:parse()[1], 'Real parse: ' .. lang)
end
buffer('lua', { 'local function first(a, b)', '  return (a + (b))', 'end', '', 'local function second(c)', '  return c', 'end' })
assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Native highlighter')
keys('yaf')
assert(vim.fn.getreg('0'):find('return %(a %+ %(b%)%)'), 'Function object yank')
assert(vim.fn.getregtype('0') == 'V', 'Function linewise')
keys(']m')
assert(vim.api.nvim_win_get_cursor(0)[1] == 5, 'Next function')
keys('[m')
assert(vim.api.nvim_win_get_cursor(0)[1] == 1, 'Previous function')
vim.api.nvim_win_set_cursor(0, { 1, 21 })
keys('yia')
assert(vim.fn.getreg('0') == 'a', 'Argument object')
buffer('python', { 'class Example:', '    def first(self, value):', '        return value', '', 'class Other:', '    pass' })
keys('yac')
assert(vim.fn.getreg('0'):find('class Example') and vim.fn.getregtype('0') == 'V', 'Class linewise')
keys(']c')
assert(vim.api.nvim_win_get_cursor(0)[1] == 5, 'Class movement')
buffer('text', { 'one two' })
keys('gziw)W.')
assert(vim.api.nvim_get_current_line() == '(one) (two)', 'Surround first operation and dot-repeat')
keys('0gzc)]')
assert(vim.api.nvim_get_current_line() == '[one] (two)', 'Surround change')
keys('gzd]')
assert(vim.api.nvim_get_current_line() == 'one (two)', 'Surround delete')
buffer('text', { 'one' })
keys('3gZ"')
assert(vim.api.nvim_get_current_line() == '"""one"""', 'Counted surround')
buffer('text', { 'one two' })
keys('viwgz]')
assert(vim.api.nvim_get_current_line() == '[one] two', 'Visual surround')
buffer('lua', { '' })
keys('i()<Esc>')
assert(vim.api.nvim_get_current_line() == '()', 'Pairs typed once')
buffer('markdown', { '# Heading', '', '- **bold** [link](https://example.com)', '', '```lua', 'local x = 1', '```' })
local original = vim.api.nvim_buf_get_lines(0, 0, -1, false)
local buf = vim.api.nvim_get_current_buf()
assert(vim.wo.spell and vim.bo.spellfile:find('en.utf%-8.add'), 'Local spell dictionary')
require('render-markdown').render({ buf = buf })
vim.wait(200)
local marks = 0
for name, ns in pairs(vim.api.nvim_get_namespaces()) do
  if name:find('render') then marks = marks + #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {}) end
end
assert(marks > 0, 'Real Markdown decorations')
keys(' um')
keys(' um')
assert(vim.deep_equal(original, vim.api.nvim_buf_get_lines(0, 0, -1, false)), 'Render preserves contents')
vim.bo.filetype = 'lua'
assert(not vim.wo.spell and vim.fn.maparg(' um', 'n') == '', 'Markdown cleanup: ' .. vim.inspect({ spell = vim.wo.spell, map = vim.fn.maparg(' um', 'n'), undo = vim.b.undo_ftplugin }))
buffer('zsh', { 'typeset -A values', 'print ${values[(k)1]}' })
assert(not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Zsh native fallback')
buffer('lua', { string.rep('x', 10001) })
assert(vim.b.dotneovim_large and not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Long-line guard')
assert(not require('rainbow-delimiters').is_enabled(0), 'Rainbow excluded')
buffer('markdown', vim.split(string.rep('text\n', 220000), '\n'))
assert(vim.b.dotneovim_large and not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], 'Size guard')
local notify = vim.notify
local warnings = {}
vim.notify = function(msg) warnings[#warnings + 1] = msg end
buffer('lua', { 'local x = 1' })
local start = vim.treesitter.start
vim.treesitter.start = function() error('unavailable parser') end
require('config.reading').attach(vim.api.nvim_get_current_buf())
vim.treesitter.start = start
vim.wait(50)
vim.notify = notify
assert(#warnings > 0 and warnings[1]:find('Missing parser'), 'Missing parser reported')
print('PASS: all real parsers/queries, objects/motions, surround first/count/dot/visual, pairs, Markdown decorations/spell/cleanup, guards/fallback')
vim.cmd('qa!')
