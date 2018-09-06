setlocal autoindent
setlocal formatoptions=tcq2l
setlocal conceallevel=2
setlocal foldmethod=syntax
setlocal foldlevel=99

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2

" Format json
nnoremap <buffer> <leader>jf :%!python -m json.tool<CR>
nnoremap <buffer> <leader>jr :%!json_reformat<CR>
nnoremap <buffer> <leader>jv :!json_verify < %<CR>
