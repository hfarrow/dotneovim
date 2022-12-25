-- vim: foldmethod=marker foldlevel=1

return function(use)
  -- {{{ Core
  use 'tpope/vim-sensible'
  -- }}}

  -- {{{ Syntax
  use {'nvim-treesitter/nvim-treesitter',
    requires = {'p00f/nvim-ts-rainbow'},
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = 'all',
        highlight = {
          enable = false,
          -- disable slow treesitter highlight for large files
          disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
          end,
        },
        indent = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end
  }

  -- }}}

  -- {{{ LSP
  -- // TODO Diagnostics, Git, lua lsp
  use {'neovim/nvim-lspconfig', commit = '3e2cc7061957292850cc386d9146f55458ae9fe3',
    config = function()
    end
  }

  use {'hrsh7th/cmp-nvim-lsp',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      local on_attach = function(client, bufnr)
        require('completion').on_attach(client)

        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        -- TODO: Move lsp mappings to function in keymaps.lua
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      --[[
      require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
        capabilities = capabilities
      }
      --]]
      -- TODO: Consider Omnisharp instead?
      require('lspconfig').csharp_ls.setup({
        capabilities = capabilities
      })

      require('lspconfig').bashls.setup({
        capabilities = capabilities
      })

      require('lspconfig').rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true
            },
          }
        }
      })

      require('lspconfig').pyright.setup({
        capabilities = capabilities
      })

      require('lspconfig').sumneko_lua.setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end
  }
  -- }}}

  -- {{{ Completion
  use {'hrsh7th/nvim-cmp',
    config = function()
      vim.opt.completeopt = 'menu,menuone,noselect'
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),

        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

    end
  }
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-git'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'

  use 'honza/vim-snippets'
  use {'L3MON4D3/LuaSnip', tag = 'v1.*',
    run = 'make install_jsregexp',
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end
  }
  -- }}}

  -- {{{ Navigation
  use {'nvim-tree/nvim-tree.lua', tag = 'nightly',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("nvim-tree").setup({})
      local fn = require('user.functions')
      fn.nbind('<Leader>tt', ':NvimTreeToggle<CR>')
    end,
  }

  use {'glepnir/dashboard-nvim',
    config = function()
      local db = require('dashboard')
      --db.preview_command = 'cat | lolcat -F 0.3'
      --db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
      --db.preview_file_height = 11
      --db.preview_file_width = 70
      db.custom_header = {
        ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
      }
      db.custom_center = {
        {icon = '  ',
        desc = 'Find File                                     ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = '\''},
        {icon = '  ',
        desc = 'Recent Files                                  ',
        action =  'Telescope oldfiles',
        shortcut = ';'},
        {icon = '  ',
        desc = 'Find Word                               ',
        action = 'Telescope live_grep',
        shortcut = 'SPC f g'},
        {icon = '  ',
        desc ='File Browser                            ',
        action =  'NvimTreeToggle',
        shortcut = 'SPC t t'},
        {icon = '  ',
        desc = 'Recent Sessions                                ',
        shortcut = '',
        action ='SessionLoad'},
        {icon = '  ',
        desc = 'Open Neovim Config                             ',
        action = 'Telescope find_files cwd=' .. require('user.functions').get_dotneovim_path(),
        shortcut = ''},
        {icon = '  ',
        desc = 'Open ~/.config                                 ',
        action = 'Telescope find_files cwd=~/.config',
        shortcut = ''},
      }
    end
  }

  use {'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  }
  --}}}

  -- {{{ Search
  use {'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('telescope').setup{
        defaults = {
          cache_picker = {
            num_pickers = 32
          },
          mappings = {
            i = {
              ['<C-J>'] = 'move_selection_next',
              ['<C-K>'] = 'move_selection_previous',
              [';']     = 'select_default',
            },
          },
        },
      }

      local builtin = require('telescope/builtin')
      local fn = require('user.functions')
      fn.nbind('\'',         builtin.find_files)
      fn.nbind(';',          builtin.oldfiles)
      fn.nbind('<Leader>fg', builtin.live_grep)
      fn.nbind('<Leader>*',  builtin.grep_string)
      fn.nbind('<Leader>fb', builtin.buffers)
      fn.nbind('<Leader>fh', builtin.help_tags)
      fn.nbind('<Leader>fc', builtin.commands)
      fn.nbind('<Leader>fr', builtin.pickers)
      fn.nbind('<Leader>fm', builtin.marks)
      fn.nbind('<Leader>fx', builtin.quickfix)
      fn.nbind('<Leader>fz', builtin.quickfixhistory)
      fn.nbind('<Leader>fo', builtin.vim_options)
      fn.nbind('<Leader>fy', builtin.registers)
      fn.nbind('<Leader>fe', builtin.resume)
      fn.nbind('<Leader>/',  builtin.current_buffer_fuzzy_find)
      fn.nbind('<Leader>fv', builtin.spell_suggest)
      fn.nbind('<Leader>fj', builtin.jumplist)
    end
  }

  use 'lfv89/vim-interestingwords'
  -- }}}

  -- {{{ Themes
  -- use 'ellisonleao/gruvbox.nvim'
  -- use 'luisiacc/gruvbox-baby'
  use 'sainnhe/gruvbox-material'
  -- }}}

  -- {{{ Writing
  -- }}}

end

