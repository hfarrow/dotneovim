local function search(kind, mode, scope)
  return function() require('config.search').open(kind, mode, scope) end
end
return {
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvimdev/dashboard-nvim', cmd = 'Dashboard', dependencies = { 'nvim-web-devicons' },
    opts = {
      theme = 'hyper', hide = { statusline = false },
      config = {
        header = {
          ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
          ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
          ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
          ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
          ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
          ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
        },
        packages = { enable = false }, project = { enable = false },
        mru = { limit = 20, cwd_only = false }, footer = {},
        shortcut = {
          { desc = 'Files', key = 'f', action = search('files', 'normal') },
          { desc = 'Hidden', key = 'F', action = search('files', 'hidden') },
          { desc = 'All', key = 'a', action = search('files', 'all') },
          { desc = 'Recent', key = ';', action = 'Telescope oldfiles' },
          { desc = 'Grep', key = '/', action = search('grep', 'normal') },
          { desc = 'Tree', key = 'e', action = 'NvimTreeToggle' },
          { desc = 'Config', key = 'c', action = function() vim.cmd.edit(vim.g.dotneovim_root .. '/init.lua') end },
        },
      },
    },
  },
  {
    'nvim-tree/nvim-tree.lua', tag = 'v1.18.0', dependencies = { 'nvim-web-devicons' },
    cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFindFile' },
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
      { '<leader>E', '<cmd>NvimTreeFindFile<cr>', desc = 'Reveal current file' },
    },
    opts = {
      hijack_netrw = false, -- Core startup disables netrw before plugin loading.
      hijack_directories = { enable = false }, sync_root_with_cwd = false,
      actions = { change_dir = { enable = false } },
      view = { width = 34 }, renderer = { group_empty = true },
      filters = { dotfiles = false, git_ignored = false, custom = { '^.git$' } },
      update_focused_file = { enable = true, update_root = false },
      on_attach = function(buf)
        local api = require('nvim-tree.api')
        api.map.on_attach.default(buf)
        vim.keymap.set('n', '?', api.tree.toggle_help, { buffer = buf, desc = 'Tree help' })
      end,
    },
  },
  {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.2', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-web-devicons' },
    cmd = 'Telescope',
    init = function() require('config.search').setup() end,
    keys = {
      { "<leader>'", search('files', 'normal'), desc = 'Find files' },
      { '<leader>fh', search('files', 'hidden'), desc = 'Find hidden files' },
      { '<leader>fa', search('files', 'all'), desc = 'Find all files (ignored)' },
      { '<leader>fp', search('files', 'normal', 'project'), desc = 'Find project files' },
      { '<leader>fg', search('grep', 'normal'), desc = 'Grep files' },
      { '<leader>fG', search('grep', 'hidden'), desc = 'Grep hidden files' },
      { '<leader>fA', search('grep', 'all'), desc = 'Grep all files (ignored)' },
      { '<leader>;', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find buffers' },
      { '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Search current buffer' },
    },
    config = function()
      local a = require('telescope.actions')
      require('telescope').setup({ defaults = {
        mappings = {
          i = { ['<C-j>'] = a.move_selection_next, ['<C-k>'] = a.move_selection_previous, ['<C-q>'] = a.send_to_qflist + a.open_qflist },
          n = { [';'] = a.select_default, ['<C-q>'] = a.send_to_qflist + a.open_qflist },
        },
      } })
    end,
  },
  { 'folke/which-key.nvim', version = '^3', event = 'VeryLazy', opts = { delay = 350, spec = {
    { '<leader>f', group = 'Files / search' }, { '<leader>u', group = 'Display' },
  } } },
  { 'nvim-lualine/lualine.nvim', event = 'VeryLazy', dependencies = { 'nvim-web-devicons' }, opts = {
    options = { theme = 'auto', globalstatus = true, component_separators = '', section_separators = '' },
    sections = { lualine_a = { 'mode' }, lualine_b = { 'branch' }, lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'diagnostics', 'filetype' }, lualine_y = { 'progress' }, lualine_z = { 'location' } },
  } },
}
