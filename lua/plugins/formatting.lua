return {
  { 'stevearc/conform.nvim', version = '^9', event = 'BufWritePre', cmd = { 'Format', 'FormatDisable', 'FormatEnable', 'ConformInfo' },
    keys = { { '<leader>ff', function() require('config.format').run(vim.api.nvim_get_current_buf(), true) end, desc = 'Format only (project policy)' } },
    config = function() require('config.format').setup() end },
}
