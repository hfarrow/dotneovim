set runtimepath+=/Users/farrh009/.local/share/dein/repos/github.com/Shougo/dein.vim

call utils#Debug("loading dein plugin manager")

" execute the call below if new plugins are not installing. If there is a script error below, it can cause issues.
" :call dein#clear_state()
" :call dein#recach_runtimepath()
"
if dein#load_state('/Users/farrh009/.local/share/dein')
  call dein#begin('/Users/farrh009/.local/share/dein')

  " Let dein manage dein
  call dein#add('/Users/farrh009/.local/share/dein/repos/github.com/Shougo/dein.vim')

  " Specify revision/branch/tag - Example:
  " call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Plugins {{{
        " Sensible Basic Settings
        call dein#add('tpope/vim-sensible')

        " Core navigation, editing, and utilities
        call dein#add('tpope/vim-repeat')
        call dein#add('tpope/vim-unimpaired')
        call dein#add('tpope/vim-surround')
        call dein#add('tpope/vim-commentary')
        call dein#add('easymotion/vim-easymotion')
        call dein#add('scrooloose/nerdtree')
        "TODO: enable easyclip when I have time to learn and configure it
        "call #dein#add('svermeulen/vim-easyclip')

        " Color Scheme
        call dein#add('morhetz/gruvbox')

        " Snippets
        call dein#add('Shougo/neosnippet.vim')
        call dein#add('Shougo/neosnippet-snippets')

        " Find and Replace
        call dein#add('junegunn/fzf', {'build': './install --all'})
        call dein#add('junegunn/fzf.vim')
  " }}} Plugins


  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install missing plugins on startup.
if dein#check_install()
  call dein#install()
endif

" Plugin customization and configuration
call utils#ConfigurePlugins('plugin_configs/')
