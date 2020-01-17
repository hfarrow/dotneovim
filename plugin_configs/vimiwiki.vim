nmap <Leader>kk <Plug>VimwikiIndex
nmap <Leader>kt <Plug>VimwikiTabIndex
nmap <Leader>ks <Plug>VimwikiUISelect
nmap <Leader>ki <Plug>VimwikiDiaryIndex
nmap <Leader>k<Leader>k <Plug>VimwikiMakeDiaryNote
nmap <Leader>k<Leader>t <Plug>VimwikiTabMakeDiaryNote
nmap <Leader>k<Leader>y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <Leader>k<Leader>m <Plug>VimwikiMakeTomorrowDiaryNote

augroup wiki
    autocmd FileType vimwiki nmap <Leader>kh <Plug>Vimwiki2HTML
    autocmd FileType vimwiki nmap <Leader>khh <Plug>Vimwiki2HTMLBrowse
    autocmd FileType vimwiki nmap <Leader>ki <Plug>VimwikiDiaryGenerateLinks
    autocmd FileType vimwiki nmap <Leader>kd <Plug>VimwikiDeleteLink
    autocmd FileType vimwiki nmap <Leader>kr <Plug>VimwikiRenameLink
augroup end

let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
