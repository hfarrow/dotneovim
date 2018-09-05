" Deoplete auto completion
let g:deoplete#sources#rust#racer_binary=$HOME . '/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$RUST_SRC_PATH
let g:deoplete#sources#rust#show_duplicates=1
" let g:deoplete#sources#rust#disable_keymap=1
" let g:deoplete#sources#rust#documentation_max_height=20

" Auto format on save
let g:rustfmt_autosave = 1
