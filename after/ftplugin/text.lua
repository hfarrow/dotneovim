vim.opt_local.spell = true
vim.opt_local.spellfile = vim.fs.joinpath(vim.g.dotneovim_root, 'spell', 'en.utf-8.add')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. ' | setlocal spell< spellfile<'
