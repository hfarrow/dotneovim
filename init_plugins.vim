" Install vim-plug plugin manager for unix based systems
if has('win32')
" TODO run setup.ps1 to initialize VimPlug for windows
" You may need to manually run :PlugInstall and there may be errors until you restart
else
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

call utils#Debug('Initializing vim-plug plugin manager')
if has('win32')
    call plug#begin('~/AppData/Local/nvim/autoload')
else
    call plug#begin('~/.local/share/nvim/plugged')
endif

        " Sensible Basic Settings
        Plug 'tpope/vim-sensible'

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

        " XML
        Plug 'othree/xml.vim'

        " Auto Completion
        if has('win32')
            " 'do' command is untested on windows. Will it run the PowerShell script?
            Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.ps1' }
        else
            Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
        endif
        Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'jiangmiao/auto-pairs'

        " Markdown / Notes
        Plug 'shime/vim-livedown'
        Plug 'vimwiki/vimwiki'

        " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

        " Programming Misc
        Plug 'scrooloose/syntastic'
        Plug 'majutsushi/tagbar'

        " Rust Programming Language
        Plug 'rust-lang/rust.vim'

call plug#end()

filetype plugin indent on
syntax enable

" Plugin customization and configuration
call utils#ConfigurePlugins('plugin_configs/')
