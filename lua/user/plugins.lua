-- vim: foldmethod=marker foldlevel=1

return function(use)
  -- {{{ Misc
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
          enable = false,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end
  }

  -- }}}

  -- {{{ LSP

  -- }}}

  -- {{{ Navigation
  use {'nvim-tree/nvim-tree.lua', tag = '0.1.0',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    tag = 'nightly',
    config = function()
      require("nvim-tree").setup({})
      local fn = require('user.functions')
      fn.nbind('<Leader>tt', ':NvimTreeToggle<CR>')
    end,
  }

  use {'glepnir/dashboard-nvim',
    config = function()
      local db = require('dashboard')
      local home = os.getenv('HOME')
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
        desc = 'Find File                               ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = 'SPC f f'},
        {icon = '  ',
        desc = 'Recent Files                            ',
        action =  'Telescope oldfiles',
        shortcut = 'SPC f r'},
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
    end
  }

  use 'lfv89/vim-interestingwords'
  -- }}}

  -- {{{ Themes
  -- use 'ellisonleao/gruvbox.nvim'
  -- use 'luisiacc/gruvbox-baby'
  use 'sainnhe/gruvbox-material'
  -- }}}
end

