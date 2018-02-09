nnoremap <Leader>ty :NERDTreeMirror<CR>
nnoremap <Leader>tt :NERDTreeToggle<CR>
nnoremap <Leader>tu :NERDTree<Space>
nnoremap <Leader>tr :NERDTreeCWD<CR>
nnoremap <Leader>tf :NERDTreeFocus<CR>
nnoremap <Leader>tf :NERDTreeFind<CR>

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

augroup plugin_nerdtree
    autocmd!

    " Close a tab if the only remaining window is NERDTree
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Open by default
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup END
