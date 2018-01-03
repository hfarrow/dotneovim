" remap <leader> to ','
let g:mapleader = ','

" Leave insert mode
inoremap jj <esc>
inoremap jk <esc>
inoremap kj <esc><Paste>

" Auto Center
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

" make * stay on current word
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
nnoremap <silent> # #zz:PulseIfEnabled<cr>
nnoremap <silent> g* g*zz:PulseIfEnabled<cr>
nnoremap <silent> g# g#zz:PulseIfEnabled<cr>
nnoremap <silent> <C-o> <C-o>zz:PulseIfEnabled<cr>
nnoremap <silent> <C-i> <C-i>zz:PulseIfEnabled<cr>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Split Windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s

" Focus Window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move to beginning or end of line
" Easier to type and I don't use the default behaivour
noremap H ^
noremap L $
vnoremap L g_

" S = Stamp replace word with last yanked text
" nnoremap S diw"0P

" Replace Word Under Cursor
nnoremap <space>c :%s/<C-r><C-w>//g<Left><Left>
" TODO: Find and replace in all files

" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" Window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" Remove trailing white space from all lines
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Select entire buffer
nnoremap Vaa ggVG

" highlighting words temporarily similar to *
" Thanks Steve Losh
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" Perforce
" TODO: Better perforce integration
" Ideas 
"   - check if file is in a directory under a .p4config to enable plugin
"   - automatically check out a file upon edit
"   - command for list of file checked out
"   - command to revert all files in changelist
"   - command to revert current file
"   - annotate current file, etc
nnoremap <leader>pc :!p4 edit %<cr>
