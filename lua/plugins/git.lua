return {
  { 'lewis6991/gitsigns.nvim', version = '^1', event = { 'BufReadPre', 'BufNewFile' }, opts = {
    current_line_blame = false, signs_staged_enable = true,
    on_attach = function(buf)
      if require('config.largefile').check(buf) then return false end
      local gs = require('gitsigns')
      local function map(mode, key, fn, desc) vim.keymap.set(mode, key, fn, { buffer = buf, desc = desc }) end
      map('n', ']h', function() gs.nav_hunk('next') end, 'Next Git hunk')
      map('n', '[h', function() gs.nav_hunk('prev') end, 'Previous Git hunk')
      map('n', '<leader>hp', gs.preview_hunk, 'Preview Git hunk')
      map('n', '<leader>hs', gs.stage_hunk, 'Stage/unstage Git hunk')
      map('n', '<leader>hr', gs.reset_hunk, 'Reset Git hunk')
      map('n', '<leader>hb', gs.blame_line, 'Blame current line')
      for key, action in pairs({ ['<leader>hs'] = gs.stage_hunk, ['<leader>hr'] = gs.reset_hunk }) do
        map('x', key, function() action({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Git selected hunk')
      end
      map({ 'x', 'o' }, 'ih', gs.select_hunk, 'Select Git hunk')
    end,
  } },
  { 'akinsho/toggleterm.nvim', version = '^2', cmd = { 'ToggleTerm', 'TermSelect' },
    keys = {
      { '<leader>th', function() require('config.terminal').shell('horizontal') end, desc = 'Horizontal shell' },
      { '<leader>tv', function() require('config.terminal').shell('vertical') end, desc = 'Vertical shell' },
      { '<leader>tf', function() require('config.terminal').shell('float') end, desc = 'Floating shell' },
      { '<leader>lg', function() require('config.terminal').git() end, desc = 'Toggle dedicated LazyGit' },
    },
    opts = { open_mapping = false, autochdir = false, shade_terminals = false,
      size = function(term) return term.direction == 'vertical' and math.floor(vim.o.columns * 0.4) or 15 end,
      persist_mode = false, close_on_exit = true, float_opts = { border = 'rounded' },
    },
  },
}
