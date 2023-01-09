local fn = require('user.functions')
local autocmd = fn.autocmd_helper('keymaps_cmds', { clear = true })

-- Helpers
local silent = fn.bind_opt.silent

------------------------------------------------------------------------------------------------------------------------
-- Key Mappings
------------------------------------------------------------------------------------------------------------------------
-- leave insert mode
fn.ibind('jj', '<Esc>')
fn.ibind('jk', '<Esc>')
fn.ibind('kj', '<Esc>')

-- auto center search
fn.nbind('n', 'nzz', silent)
fn.nbind('N', 'Nzz', silent)

-- reselect visual block after indent
fn.vbind('<', '<gv')
fn.vbind('>', '>gv')

-- window selection
fn.nbind('<C-h>', '<C-w>h')
fn.nbind('<C-j>', '<C-w>j')
fn.nbind('<C-k>', '<C-w>k')
fn.nbind('<C-l>', '<C-w>l')

-- move to beginning or end of line
fn.nbind('H', '^')
fn.nbind('L', '$')
fn.vbind('H', '^')
fn.vbind('L', 'g_')

-- black hole register deleting and pasting
-- 'dd', 'x' will no longer yank text.
fn.nxbind('d', '"_d')
fn.nxbind('D', '"_D')
fn.nxbind('x', '"_x')
fn.nxbind('X', '"_X')
fn.nxbind('c', '"_c')
fn.nxbind('C', '"_C')
fn.nxbind('<Leader>d', 'd')
fn.nxbind('<Leader>D', 'D')
fn.nxbind('<Leader>x', 'x')
fn.nxbind('<Leader>X', 'X')
fn.nxbind('<Leader>c', 'c')
fn.nxbind('<Leader>C', 'C')
fn.xbind('<Leader>p', '"_dP')

-- make 'Y' consistent with 'C' and 'D'. See :help Y
fn.nbind('Y', 'y$')

-- break undo at line boundries, braces, parent, brackets
fn.ibind('<CR>', '<CR><C-g>u')

-- format current paragraph
fn.nbind('<CR>', 'gwip')

------------------------------------------------------------------------------------------------------------------------
-- Terminal Mappings
------------------------------------------------------------------------------------------------------------------------
autocmd('TermOpen', {
  desc = "Return to normal mode (buffer local)",
  callback = function(_)
    fn.tbind('<Esc>', '<C-\\><C-n>', { buffer = true })
  end
})

------------------------------------------------------------------------------------------------------------------------
-- Command Mappings
------------------------------------------------------------------------------------------------------------------------
-- make * stay on current word
fn.nbind('*', ':let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>', silent)

-- select all text
fn.nbind('<Leader>a', ':keepjumps normal! ggVG<CR>')

-- change to directory of current file
fn.nbind('<Leader>cd', ':cd %:p:h <CR>')

-- remove trailing white space in buffer
fn.nbind('<Leader>ww', 'mz:%s/\\s\\+$//<cr>:let @/=\'\'<cr>`z')

-- move lines
fn.nbind('<A-j>', ':m .+1<CR>==')
fn.nbind('<A-k>', ':m .-2<CR>==')
fn.ibind('<A-j>', '<Esc>:m .+1<CR>==gi')
fn.ibind('<A-k>', '<Esc>:m .-2<CR>==gi')
fn.vbind('<C-j>', ":m '>+1<CR>gv=gv")
fn.vbind('<C-k>', ":m '<-2<CR>gv=gv")

------------------------------------------------------------------------------------------------------------------------
-- Toggles
------------------------------------------------------------------------------------------------------------------------
-- Search result highlight
fn.nbind('<Leader>uh', '<cmd>set invhlsearch<CR>')
fn.nbind('<Leader><CR>', '<cmd>noh<CR>')

-- Tabline
fn.nbind('<Leader>ut', fn.toggle_opt('showtabline', 'o', 1, 0))

-- Line length ruler
fn.nbind('<Leader>ul', fn.toggle_opt('colorcolumn', 'wo', '+1', '0'))

-- Cursorline highlight
fn.nbind('<Leader>uc', '<cmd>set invcursorline<CR>')

-- Line numbers
fn.nbind('<Leader>un', '<cmd>set invnumber<CR>')

-- Relative line numbers
fn.nbind('<Leader>ur', '<cmd>set invrelativenumber<CR>')
