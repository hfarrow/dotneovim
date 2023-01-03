-- vim: foldmethod=marker foldlevel=1

local lsp_lines_active = true
local lsp_only_current_line = false

local f = require('user.functions')
local autocmd = f.autocmd_helper('plugins', { clear = true })


local configure_plugins = function(use)
  -- {{{ Core
  use { 'tpope/vim-sensible' }
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

  use { 'kkharji/sqlite.lua' }
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

      local on_attach = function(_, bufnr)
        -- Mappings
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local builtin = require('telescope/builtin')
        local lsp_opts = { noremap = true, silent = true, buffer = bufnr }
        fn.nbind('gD', vim.lsp.buf.declaration, lsp_opts)
        fn.nbind('gd', builtin.lsp_definitions, lsp_opts)
        fn.nbind('<Leader>gd', builtin.lsp_type_definitions, lsp_opts)
        fn.nbind('gi', builtin.lsp_implementations, lsp_opts)
        fn.nbind('gr', builtin.lsp_references, lsp_opts)
        fn.nbind('K', vim.lsp.buf.hover, lsp_opts)
        fn.nbind('<C-k>', vim.lsp.buf.signature_help, lsp_opts)
        fn.nbind('<Leader>fS', builtin.lsp_document_symbols)
        fn.nbind('<Leader>fs', builtin.lsp_dynamic_workspace_symbols)
        fn.nbind('<Leader>fa', builtin.lsp_workspace_symbols)
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
          ['rust-analyzer'] = {
            imports = {
              granularity = {
                group = 'module',
              },
              prefix = 'self',
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

      require('lspconfig').yamlls.setup({

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
          {
            name = 'spell',
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return require('cmp.config.context').in_treesitter_capture('spell')
              end,
            },
          },
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
      fn.nbind('<Leader>y', ':NvimTreeToggle<CR>')
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
          shortcut = 'SPC y' },
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

  use { 'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<C-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>s'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>S'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      }
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
      fn.nbind('<Leader>fq', builtin.quickfix)
      fn.nbind('<Leader>fQ', builtin.quickfixhistory)
      fn.nbind('<Leader>fo', builtin.vim_options)
      fn.nbind('<Leader>fy', builtin.registers)
      fn.nbind('<Leader>fe', builtin.resume)
      fn.nbind('<Leader>/', builtin.current_buffer_fuzzy_find)
      fn.nbind('<Leader>fz', builtin.spell_suggest)
      fn.nbind('<Leader>fj', builtin.jumplist)
      fn.nbind('<Leader>f<Leader>', builtin.keymaps)
      fn.nbind('<Leader>fx', builtin.diagnostics)
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
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
        kopts)
      fn.nbind('N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
        kopts)
      fn.nbind('*',
        [[:let stay_star_view = winsaveview()<CR>*<Cmd>lua require('hlslens').start()<CR>:call winrestview(stay_star_view)<cr>]]
        , kopts)
      fn.nbind('#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      fn.nbind('<Leader>l', '<Cmd>noh<CR>', kopts)
    end,
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
        vim.diagnostic.config({ virtual_lines = { only_current_line = not lsp_only_current_line } })
        lsp_only_current_line = not lsp_only_current_line
      end

      local fn = require('user.functions')
      fn.nbind('<Leader>ux', toggle, { desc = "Toggle lsp_lines and virtual_text" })
      fn.nbind('<Leader>uX', toggle_current_line_only, { desc = "Toggle virtual_lines - current line only" })
    end,
  }

  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox-material'
        }
      })
    end
  }

  use { 'romgrk/barbar.nvim',
    wants = 'nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,
        icon_pinned = '車',
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '' },
          [vim.diagnostic.severity.WARN] = { enabled = true, icon = '' },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        }
      })

      local nvim_tree_events = require('nvim-tree.events')
      local bufferline_api = require('bufferline.api')

      local function get_tree_size()
        return require 'nvim-tree.view'.View.width
      end

      nvim_tree_events.subscribe('TreeOpen', function()
        bufferline_api.set_offset(get_tree_size())
      end)

      nvim_tree_events.subscribe('Resize', function()
        bufferline_api.set_offset(get_tree_size())
      end)

      nvim_tree_events.subscribe('TreeClose', function()
        bufferline_api.set_offset(0)
      end)

      local fn = require('user.functions')
      local opts = fn.bind_opt.silent

      -- Move to previous/next
      fn.nbind('<A-,>', '<Cmd>BufferPrevious<CR>', opts)
      fn.nbind('<A-.>', '<Cmd>BufferNext<CR>', opts)
      -- Re-order to previous/next
      fn.nbind('<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      fn.nbind('<A->>', '<Cmd>BufferMoveNext<CR>', opts)
      -- Goto buffer in position...
      fn.nbind('<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      fn.nbind('<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      fn.nbind('<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      fn.nbind('<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      fn.nbind('<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      fn.nbind('<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      fn.nbind('<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      fn.nbind('<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      fn.nbind('<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
      fn.nbind('<A-0>', '<Cmd>BufferLast<CR>', opts)
      -- Pin/unpin buffer
      fn.nbind('<A-p>', '<Cmd>BufferPin<CR>', opts)
      -- Close buffer
      fn.nbind('<A-c>', '<Cmd>BufferClose<CR>', opts)
      -- Wipeout buffer
      --                 :BufferWipeout
      -- Close commands
      --                 :BufferCloseAllButCurrent
      --                 :BufferCloseAllButPinned
      --                 :BufferCloseAllButCurrentOrPinned
      --                 :BufferCloseBuffersLeft
      --                 :BufferCloseBuffersRight
      -- Magic buffer-picking mode
      fn.nbind('<C-p>', '<Cmd>BufferPick<CR>', opts)
      -- Sort automatically by...
      fn.nbind('<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
      fn.nbind('<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
      fn.nbind('<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
      fn.nbind('<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    end
  }
  -- }}}

  -- {{{ Git
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
      require("scrollbar.handlers.gitsigns").setup()
    end
  }

  use { 'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
    end
  }
  --}}}

  --{{{ Terminal
  use { "akinsho/toggleterm.nvim", tag = '*',
    config = function()
      require("toggleterm").setup()

      local fn       = require('user.functions')
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit  = Terminal:new({
        cmd = 'lazygit',
        hidden = true,
        direction = 'float',
        on_open = function(_)
          require('user.functions').tunbind('<Esc>', { buffer = true })
        end,
        float_opts = {
          border = 'single',
          winblend = 0,
          width = function()
            return math.ceil(vim.o.columns * 1.0)
          end,
          height = function()
            return math.ceil(vim.o.lines * 1.0)
          end,
          highlights = {
            border = "FloatBorder",
            background = "NormalFloat",
          },
        },
      })

      function _Lazygit_toggle()
        lazygit:toggle()
      end

      fn.nbind('<leader>lg', '<cmd>lua _Lazygit_toggle()<CR>', { noremap = true, silent = true })
      fn.nbind('<leader>tt', ':ToggleTerm direction=tab<CR>')
      fn.nbind('<leader>tf', ':ToggleTerm direction=float<CR>')
      fn.nbind('<leader>tv', ':ToggleTerm direction=vertical<CR>')
      fn.nbind('<leader>th', ':ToggleTerm direction=horizontal<CR>')
    end }
  --}}}

  -- {{{ Themes
  -- use 'ellisonleao/gruvbox.nvim'
  -- use 'luisiacc/gruvbox-baby'
  use 'sainnhe/gruvbox-material'
  -- }}}

  -- {{{ Writing
  use { 'ellisonleao/glow.nvim',
    config = function()
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

  use { 'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use { 'folke/zen-mode.nvim',
    config = function()
      require("zen-mode").setup {
      }
    end
  }

  use { 'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          insert          = '<C-g>z',
          insert_line     = 'gC-ggZ',
          normal          = 'gz', -- ex: 'gziw' instead of 'ysiw'
          normal_cur      = 'gZ',
          normal_line     = 'gzz',
          normal_cur_line = 'gZZ',
          visual          = 'gz',
          visual_line     = 'gZ',
          delete          = 'gzd',
          change          = 'gzc',
        }
      })
    end
  }

  use { 'AckslD/nvim-neoclip.lua',
    requires = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require('telescope').load_extension('neoclip')
      require('neoclip').setup({
        enable_persistent_history = true,
        continuous_sync = true,
        keys = {
          telescope = {
            i = {
              select = '<cr>',
              paste = ';',
              paste_behind = '<c-p>',
              replay = '<c-q>', -- replay a macro
              delete = '<c-d>', -- delete an entry
              custom = {},
            },
            n = {
              select = '<cr>',
              paste = {';', 'p',},
              paste_behind = {':', 'P' },
              replay = 'q',
              delete = 'd',
              custom = {},
            },
          },
        },
      })
      require('user.functions').nbind('<Leader>fp', ':Telescope neoclip<CR>', lsp_opts)
    end,
  }
  -- }}}
end

-- {{{ Packer
local ensure_packer = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

autocmd('BufWritePost', {
  desc = 'Compile Packer on config save',
  pattern = { 'plugins.lua' },
  callback = function(_)
    vim.api.nvim_command('source <afile>')
    vim.api.nvim_command('PackerCompile')
  end
})

local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  configure_plugins(use)

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- }}}
