" Mapping selecting mappings
nmap <Leader><Tab> <Plug>(fzf-maps-n)
xmap <Leader><Tab> <Plug>(fzf-maps-x)
omap <Leader><Tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <Plug>(fzf-complete-word)
imap <c-x><c-f> <Plug>(fzf-complete-path)
imap <c-x><c-j> <Plug>(fzf-complete-file-ag)
imap <c-x><c-l> <Plug>(fzf-complete-line)

" Finders
nnoremap ; :Buffers<CR>
nnoremap <Leader>; :Files<CR>
nnoremap <Leader>f :Ag 
nnoremap <Leader>g :Tags<CR>
nnoremap <Leader>m :Marks<CR>
nnoremap <Leader>r :History<CR>
nnoremap <Leader>h :History:<CR>
nnoremap <Leader>/ :History/<CR>
