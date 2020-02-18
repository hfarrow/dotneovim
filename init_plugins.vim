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
if exists('g:vscode')
    Plug 'asvetliakov/vim-easymotion', {'as': "vscode-vim-easymotion"}
else
    Plug 'easymotion/vim-easymotion'
    Plug 'scrooloose/nerdtree'
endif
" TODO: enable easyclip when I have time to learn and configure it
" Plug 'svermeulen/vim-easyclip'

" Color Scheme
if !exists('g:vscode')
    Plug 'morhetz/gruvbox'
endif

" Snippets
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'

" Find and Replace
if !exists('g:vscode')
    Plug 'junegunn/fzf', {'do': './install --all'}
    Plug 'junegunn/fzf.vim'
endif

" JSON
if !exists('g:vscode')
    Plug 'elzr/vim-json'
endif

" XML
if !exists('g:vscode')
    Plug 'othree/xml.vim'
endif

" Auto Completion
if !exists('g:vscode')
    if has('win32')
        " 'do' command is untested on windows. Will it run the PowerShell script?
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.ps1' }
    else
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
    endif
endif

if !exists('g:vscode')
    Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'jiangmiao/auto-pairs'
endif

" Markdown / Notes
if !exists('g:vscode')
    Plug 'shime/vim-livedown'
    Plug 'vimwiki/vimwiki'
endif

" Git
if !exists('g:vscode')
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
endif

" Programming Misc
if !exists('g:vscode')
    Plug 'scrooloose/syntastic'
    Plug 'majutsushi/tagbar'
endif

" Rust Programming Language
if !exists('g:vscode')
    Plug 'rust-lang/rust.vim'
endif

call plug#end()

filetype plugin indent on
syntax enable

" Plugin customization and configuration
call utils#ConfigurePlugins('plugin_configs/')
