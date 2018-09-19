" Install vim-plug plugin manager for unix based systems
if has('win32')
" TODO automatically install VimPlug for windows using the following PowerShell script:
    "md ~\AppData\Local\nvim\autoload
    "$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    "(New-Object Net.WebClient).DownloadFile(
    "  $uri,
    "  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "    "~\AppData\Local\nvim\autoload\plug.vim"
    "  )
    ")
" For now, run the above script manually then comment out init.vim. Run nvim and execute
" :PlugInstall. Uncomment init.vim and restart nvim... there shouldn't be any errors.
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

        " Auto Completion
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
        Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'jiangmiao/auto-pairs'

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
