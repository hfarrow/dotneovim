" Install vim-plug plugin manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call utils#Debug('Initializing vim-plug plugin manager')
call plug#begin('~/.local/share/nvim/plugged')

       " Core navigation, editing, and utilities
       Plug 'tpope/vim-repeat'
       Plug 'tpope/vim-unimpaired'
       Plug 'tpope/vim-surround'
       Plug 'tpope/vim-commentary'
       Plug 'easymotion/vim-easymotion'
       Plug 'scrooloose/nerdtree'
       " TODO: enable easyclip when I have time to learn and configure it
       " Plug 'svermeulen/vim-easyclip'

       " Color Scheme
       Plug 'morhetz/gruvbox'

       " Snippets
       " Plug 'Shougo/neosnippet.vim'
       " Plug 'Shougo/neosnippet-snippets'

       " Find and Replace
       Plug 'junegunn/fzf', {'do': './install --all'}
       Plug 'junegunn/fzf.vim'

       " JSON
       Plug 'elzr/vim-json'

call plug#end()

filetype plugin indent on
syntax enable

" Plugin customization and configuration
call utils#ConfigurePlugins('plugin_configs/')
