vim.opt_local.spell = true

local autocmd = require('user.functions').autocmd_helper('markdown_local', { clear = true })
-- Autoformat the current paragraph when leaving insert mode. This simulates 'set fo+=a' which is not used because it
-- cmp was deleting surrounding words when a completion was executed.
autocmd({ 'InsertLeave' }, {
  desc = "Format paragraph when leaving insert mode. ",
  command = ':normal! gqip'
})
