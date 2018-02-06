setlocal autoindent
setlocal formatoptions=tcq2l
setlocal conceallevel=2
setlocal foldmethod=syntax
setlocal foldlevel=99

" Format json
nnoremap <buffer> <leader>jf :%!python -m json.tool<CR>
nnoremap <buffer> <leader>jr :%!json_reformat<CR>
nnoremap <buffer> <leader>jv :!json_verify < %<CR>
