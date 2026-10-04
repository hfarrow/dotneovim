vim.opt_local.spell = true
vim.opt_local.spellfile = vim.fs.joinpath(vim.g.dotneovim_root, 'spell', 'en.utf-8.add')
vim.keymap.set('n', '<leader>um', function() require('render-markdown').buf_toggle() end, { buffer = true, desc = 'Toggle Markdown render/raw' })
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. ' | setlocal spell< spellfile< | call v:lua.vim.keymap.del("n", "<leader>um", {"buffer": 0})'
