return {
  { 'nvim-treesitter/nvim-treesitter', branch = 'main', lazy = false,
    config = function() require('nvim-treesitter').setup({}); require('config.reading').setup() end },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', lazy = false, opts = {
    select = { lookahead = true, selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V', ['@parameter.outer'] = 'v' } },
    move = { set_jumps = true },
  } },
  { 'HiPhish/rainbow-delimiters.nvim', lazy = false,
    init = function()
      vim.g.rainbow_delimiters = { strategy = { [''] = function(buf)
        if require('config.largefile').check(buf) then return nil end
        return require('rainbow-delimiters').strategy['global']
      end } }
    end },
  { 'kylechui/nvim-surround', version = '^4', lazy = false,
    init = function()
      vim.g.nvim_surround_no_mappings = true
      for _, item in ipairs({
        { 'n', 'gz', 'normal' }, { 'n', 'gZ', 'normal-cur' }, { 'n', 'gzz', 'normal-line' }, { 'n', 'gZZ', 'normal-cur-line' },
        { 'n', 'gzd', 'delete' }, { 'n', 'gzc', 'change' }, { 'x', 'gz', 'visual' }, { 'x', 'gZ', 'visual-line' },
        { 'i', '<C-g>z', 'insert' }, { 'i', '<C-g>Z', 'insert-line' },
      }) do vim.keymap.set(item[1], item[2], '<Plug>(nvim-surround-' .. item[3] .. ')', { desc = 'Surround ' .. item[3] }) end
    end },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = { check_ts = false,
    enabled = function(buf) return not require('config.largefile').check(buf) end } },
  { url = 'https://codeberg.org/andyg/leap.nvim', name = 'leap.nvim', lazy = false,
    init = function()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'Leap in current window' })
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap across windows' })
    end },
  { 'MeanderingProgrammer/render-markdown.nvim', version = '^8', ft = 'markdown',
    -- Load before ordinary Markdown FileType so lazy's replay cannot execute
    -- native Markdown undo/unmap twice during first file startup (E31).
    event = { 'BufReadPre *.md,*.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn', 'BufNewFile *.md,*.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn' },
    dependencies = { 'nvim-treesitter', 'nvim-web-devicons' }, opts = {
      file_types = { 'markdown' }, render_modes = { 'n' }, max_file_size = 1,
      ignore = function(buf) return require('config.largefile').check(buf) end,
      completions = { lsp = { enabled = false } }, latex = { enabled = false },
    } },
}
