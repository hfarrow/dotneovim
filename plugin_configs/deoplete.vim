let g:deoplete#enable_at_startup=1

" Use Tab and Shift-Tab to cycle through candidates
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Close the preview window after completion is done.
" autocmd CompleteDone * silent! pclose!
" autocmd InsertLeave * silent! pclose!

" Disable the preview window feature
" set completeopt-=preview
