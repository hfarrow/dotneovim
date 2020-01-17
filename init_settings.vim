" Allow sensible setting to be overriden. Normally they are sourced after init.vim.
runtime! plugin/sensible.vim

" Misc
set number
set textwidth=120
set formatoptions+=1
set mouse=a
set list
set visualbell
set lazyredraw
set showmatch
set matchtime=3
set splitbelow
set splitright
set autowrite
set noautoread
set shiftround
set title
set colorcolumn=+1
" set cmdheight=2
set backup

" Indents and Tabs
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" Allow pasting from OS clipboard with 'P'
set clipboard+=unnamedplus

" Time out on key codes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10

" ignore case when searching unless there is at least one uppercase character
set ignorecase
set smartcase

" Cancel out of a mapping manually and return to insert mode.
inoremap <C-d> <esc>a

" Use ag (silver searcher) for grep program
" if executable('ag')
"     set grepprg=ag\ --nogroup
"     command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
" endif

" persistent undo
if exists('+undofile')
   set undofile
endif

set backupdir-=.

call utils#EnsureExists(&undodir)
call utils#EnsureExists(&backupdir)
call utils#EnsureExists(&directory)

" Do not show trailing whtite space in insert mode.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:⌴
    au InsertLeave * :set listchars+=trail:⌴
augroup END

" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

augroup auto_read_write
    " Save when losing focus
    au FocusLost * :silent! wall

    " Reload when gaining foucs
    au FocusGained * :silent! checktime
    au BufEnter * :silent! checktime
augroup END

" Resize splits when the window is resized
au VimResized * :wincmd =

" Ensure accidently typing :W instead of :w will still save the buffer
command! W write

" Ensure accidently typing :Q instead of :w will still quit the buffer
command! Q quit
