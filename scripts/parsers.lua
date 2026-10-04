local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')))
vim.o.loadplugins = true
dofile(root .. '/init.lua')
assert(vim.fn.executable('tree-sitter') == 1, 'Install tree-sitter-cli >=0.26.1 (brew install tree-sitter-cli)')
local parsers = require('config.reading').parsers
-- update also rebuilds already installed parsers at the locked plugin's revisions.
require('nvim-treesitter').update(parsers):wait(300000)
for _, lang in ipairs(parsers) do
  assert(pcall(vim.treesitter.language.add, lang), 'Parser installation failed: ' .. lang)
  assert(vim.treesitter.query.get(lang, 'highlights'), 'Missing highlight queries: ' .. lang)
end
print('Focused parser provisioning complete; revisions are pinned by the Tree-sitter plugin lock.')
