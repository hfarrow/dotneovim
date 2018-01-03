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

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark = 'medium'

colorscheme gruvbox
set background=dark

" TODO: Set 'guifont' to Consolas
