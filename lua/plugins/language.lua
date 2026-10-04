return {
  { 'mason-org/mason.nvim', version = '^2', lazy = false, priority = 900,
    opts = { PATH = 'prepend', registry_cache = { refresh = false }, ui = { check_outdated_packages_on_open = false } } },
  { 'saghen/blink.cmp', version = 'v1.10.2', event = 'InsertEnter',
    opts = {
      enabled = function() return vim.bo.buftype == '' and not require('config.largefile').check(0) end,
      keymap = { preset = 'none',
        ['<C-space>'] = { 'show' }, ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' }, ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-y>'] = { function(cmp) if cmp.get_selected_item() then return cmp.accept() end; return true end },
        ['<CR>'] = { 'fallback' }, ['<Tab>'] = { 'snippet_forward', 'fallback' }, ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },
      snippets = { preset = 'default' }, sources = { default = { 'lsp', 'path', 'buffer' } },
      completion = { list = { selection = { preselect = false, auto_insert = false } }, accept = { auto_brackets = { enabled = false } } },
      fuzzy = { implementation = (vim.g.dotneovim_install or vim.env.DOTNEOVIM_BLINK_LUA == '1') and 'lua' or 'prefer_rust',
        prebuilt_binaries = { download = vim.g.dotneovim_install == true } },
      cmdline = { enabled = false }, term = { enabled = false },
    },
    config = function(_, opts)
      -- Provisioning already checked the binary checksum and locked receipt.
      -- Use it synchronously so first InsertEnter/typed text is never missed,
      -- and routine startup does not spawn git/download discovery processes.
      local download = require('blink.cmp.fuzzy.download')
      local original = download.ensure_downloaded
      local matcher = 'lua'
      if not vim.g.dotneovim_install and vim.env.DOTNEOVIM_BLINK_LUA ~= '1' then
        local files = require('blink.cmp.fuzzy.download.files')
        local ok, receipt = pcall(vim.fn.readfile, files.version_path)
        local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.g.dotneovim_root .. '/lazy-lock.json'), '\n'))
        if ok and receipt[1] == lock['blink.cmp'].commit and pcall(require, 'blink.cmp.fuzzy.rust') then
          matcher = 'rust'
        else
          vim.schedule(function() vim.notify('Blink native matcher missing: run nvim -l scripts/install.lua; using Lua', vim.log.levels.WARN) end)
        end
      end
      download.ensure_downloaded = function(callback) callback(nil, matcher) end
      require('blink.cmp').setup(opts)
      download.ensure_downloaded = original
      if require('blink.cmp.config').enabled() then
        local keymap = require('blink.cmp.keymap')
        require('blink.cmp.keymap.apply').keymap_to_current_buffer(keymap.get_mappings(require('blink.cmp.config').keymap, 'default'))
      end
    end },
  { 'neovim/nvim-lspconfig', version = '^2', ft = { 'sh', 'bash', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'lua', 'python' }, dependencies = { 'mason.nvim', 'blink.cmp' },
    config = function() require('config.lsp').setup(); require('config.lint').setup() end },
}
