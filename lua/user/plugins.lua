-- vim: foldmethod=marker foldlevel=1

local lsp_lines_active = true
local lsp_only_current_line = false

return function(use)
  -- {{{ Core
  use 'tpope/vim-sensible'
  -- }}}

  -- {{{ Syntax
  use { 'nvim-treesitter/nvim-treesitter',
    requires = { 'p00f/nvim-ts-rainbow' },
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = 'all',
        highlight = {
          enable = true,
          -- disable slow treesitter highlight for large files
          disable = function(_, buf)
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
  use { 'neovim/nvim-lspconfig', commit = '3e2cc7061957292850cc386d9146f55458ae9fe3',
    config = function()
    end
  }

  use { 'hrsh7th/cmp-nvim-lsp',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local diag_opts = { noremap = true, silent = true }
      local fn = require('user.functions')
      fn.nbind('[x', function() vim.diagnostic.goto_prev({ float = false }) end, diag_opts)
      fn.nbind(']x', function() vim.diagnostic.goto_next({ float = false }) end, diag_opts)
      fn.nbind('<space>q', vim.diagnostic.setloclist, diag_opts)

      local on_attach = function(client, bufnr)
        -- Mappings
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local builtin = require('telescope/builtin')
        local fn = require('user.functions')
        local lsp_opts = { noremap = true, silent = true, buffer = bufnr }
        fn.nbind('gD', vim.lsp.buf.declaration, lsp_opts)
        fn.nbind('gd', builtin.lsp_definitions, lsp_opts)
        fn.nbind('<Leader>gd', builtin.lsp_type_definitions, lsp_opts)
        fn.nbind('gi', builtin.lsp_implementations, lsp_opts)
        fn.nbind('gr', builtin.lsp_references, lsp_opts)
        fn.nbind('K', vim.lsp.buf.hover, lsp_opts)
        fn.nbind('<C-k>', vim.lsp.buf.signature_help, lsp_opts)
        fn.nbind('<Leader>wa', vim.lsp.buf.add_workspace_folder, lsp_opts)
        fn.nbind('<Leader>wr', vim.lsp.buf.remove_workspace_folder, lsp_opts)
        fn.nbind('<Leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, lsp_opts)
        fn.nbind('<Leader>rn', vim.lsp.buf.rename, lsp_opts)
        fn.nbind('<Leader>ca', vim.lsp.buf.code_action, lsp_opts)
        fn.nbind('<Leader>ff', function() vim.lsp.buf.format { async = true } end, lsp_opts)
      end
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      --[[
      require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
        capabilities = capabilities
      }
      --]]
      -- TODO: Consider Omnisharp instead?
      require('lspconfig').csharp_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      require('lspconfig').bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
        capabilities = capabilities,
        on_attach = on_attach,
      })

      require('lspconfig').sumneko_lua.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
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
  use { 'hrsh7th/nvim-cmp',
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
            require 'luasnip'.lsp_expand(args.body)
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
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-git'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'saadparwaiz1/cmp_luasnip'

  use 'honza/vim-snippets'
  use { 'L3MON4D3/LuaSnip', tag = 'v1.*',
    run = 'make install_jsregexp',
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end
  }

  use { 'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })

      -- insert `(` after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

    end
  }

  -- }}}

  -- {{{ Navigation
  use { 'nvim-tree/nvim-tree.lua', tag = 'nightly',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("nvim-tree").setup({})
      local fn = require('user.functions')
      fn.nbind('<Leader>tt', ':NvimTreeToggle<CR>')
    end,
  }

  use { 'glepnir/dashboard-nvim',
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
        { icon = '  ',
          desc = 'Find File                                     ',
          action = 'Telescope find_files find_command=rg,--hidden,--files',
          shortcut = '\'' },
        { icon = '  ',
          desc = 'Recent Files                                  ',
          action = 'Telescope oldfiles',
          shortcut = ';' },
        { icon = '  ',
          desc = 'Find Word                               ',
          action = 'Telescope live_grep',
          shortcut = 'SPC f g' },
        { icon = '  ',
          desc = 'File Browser                            ',
          action = 'NvimTreeToggle',
          shortcut = 'SPC t t' },
        { icon = '  ',
          desc = 'Recent Sessions                                ',
          shortcut = '',
          action = 'SessionLoad' },
        { icon = '  ',
          desc = 'Open Neovim Config                             ',
          action = 'Telescope find_files cwd=' .. require('user.functions').get_dotneovim_path(),
          shortcut = '' },
        { icon = '  ',
          desc = 'Open ~/.config                                 ',
          action = 'Telescope find_files cwd=~/.config',
          shortcut = '' },
      }
    end
  }

  use { 'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  }
  --}}}

  -- {{{ Search
  use { 'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local trouble = require("trouble.providers.telescope")
      require('telescope').setup {
        defaults = {
          cache_picker = {
            num_pickers = 32
          },
          mappings = {
            i = {
              ['<C-J>'] = 'move_selection_next',
              ['<C-K>'] = 'move_selection_previous',
              [';']     = 'select_default',
              ["<c-t>"] = trouble.open_with_trouble,
            },
            n = {
              ["<c-t>"] = trouble.open_with_trouble
            },
          },
        },
      }

      local builtin = require('telescope/builtin')
      local fn = require('user.functions')
      fn.nbind('\'', builtin.find_files)
      fn.nbind(';', builtin.oldfiles)
      fn.nbind('<Leader>fg', builtin.live_grep)
      fn.nbind('<Leader>*', builtin.grep_string)
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
      fn.nbind('<Leader>/', builtin.current_buffer_fuzzy_find)
      fn.nbind('<Leader>fv', builtin.spell_suggest)
      fn.nbind('<Leader>fj', builtin.jumplist)
      fn.nbind('<Leader>f<Leader>', builtin.keymaps)
    end
  }

  -- }}}

  -- {{{ Display and Diagnostics
  use 'lfv89/vim-interestingwords'

  use { 'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end
  }

  use { 'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      require("scrollbar.handlers.search").setup({
      })

      local kopts = { noremap = true, silent = true }
      local fn = require('user.functions')
      fn.nbind('n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      fn.nbind('N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      fn.nbind('*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('<Leader>l', '<Cmd>noh<CR>', kopts)
    end,
  }

  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
      require("scrollbar.handlers.gitsigns").setup()
    end
  }

  use { 'folke/trouble.nvim',
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require('trouble').setup({})

      -- Set signs for gutter manually because Trouble was not doing so. Might be specific to newer versions of Vim and
      -- older versions of Trouble
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Information = " "
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local fn = require('user.functions')
      local opts = fn.bind_opt.silent
      fn.nbind("<leader>xx", "<cmd>TroubleToggle<cr>", opts)
      fn.nbind("<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
      fn.nbind("<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
      fn.nbind("<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)
      fn.nbind("<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
      fn.nbind("gR", "<cmd>TroubleToggle lsp_references<cr>", opts)
    end
  }

  use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })

      local function toggle()
        require("lsp_lines").toggle()
        vim.diagnostic.config({ virtual_text = not lsp_lines_active })
        lsp_lines_active = not lsp_lines_active
      end

      local function toggle_current_line_only()
        vim.diagnostic.config({ virtual_lines = {only_current_line = not lsp_only_current_line }})
        lsp_only_current_line = not lsp_only_current_line
      end

      local fn = require('user.functions')
      fn.nbind('<Leader>ux', toggle, { desc = "Toggle lsp_lines and virtual_text" })
      fn.nbind('<Leader>uX',toggle_current_line_only, { desc = "Toggle virtual_lines - current line only" })
    end,
  }
  -- }}}

  -- {{{ Themes
  -- use 'ellisonleao/gruvbox.nvim'
  -- use 'luisiacc/gruvbox-baby'
  use 'sainnhe/gruvbox-material'
  -- }}}

  -- {{{ Writing
  use {'ellisonleao/glow.nvim',
    config = function ()
      require('glow').setup({
        glow_path = '/usr/bin/glow',
        install_path = "~/.local/bin",
        border = "shadow",
        style = "dark",
        pager = false,
        width = 120,
        height = 1000,
        width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
        height_ratio = 0.9,
      })
    end
  }

  use {'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- }}}

end
