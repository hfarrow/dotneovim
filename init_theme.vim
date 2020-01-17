if !exists('g:vscode')

" Italics in iterm2 require a TERM entry: https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
" Add the following to a file named xterm-256color-italic.terminfo
"
" ============================================================================
"# A xterm-256color based TERMINFO that adds the escape sequences for italic.
"xterm-256color-italic|xterm with 256 colors and italic,
" sitm=\E[3m, ritm=\E[23m,
" use=xterm-256color,
" ============================================================================
"
" From terminal register the entry: tic xterm-256color-italic.terminfo
" In iTerm2 preferences change the "Report Terminal Type" field to "xterm-256color-italic" and restart iTerm2

"set termguicolors

if has('win32')
    let g:gruvbox_italic=0
else
    let g:gruvbox_italic=1
endif

let g:gruvbox_contrast_dark = 'medium'

colorscheme gruvbox
set background=dark

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

endif " !exists('g:vscode')
