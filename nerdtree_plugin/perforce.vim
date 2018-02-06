if exists("g:loaded_nerdtree_perforce")
    finish
endif
let g:loaded_nerdtree_perforce = 1

" TODO: Better perforce integration
" Ideas 
"   - check if file is in a directory under a .p4config to enable plugin
"   - automatically check out a file upon edit
"   - command for list of file checked out
"   - command to revert all files in changelist
"   - command to revert current file
"   - annotate current file, etc

" Checkout current file
nnoremap <leader>pc :!p4 edit %<cr>

" NERDTree menu
let submenu = NERDTreeAddSubmenu({
            \ 'text': '(p)erforce',
            \ 'shortcut': 'p',
            \ 'isActiveCallback': 'NERDTree_perforceEnabled' })
" TODO: Only show sub menu if a .p4config can be found in the file directory or any parent

call NERDTreeAddMenuItem({
            \ 'text': '(e)dit',
            \ 'shortcut': 'e',
            \ 'callback': 'NERDTree_p4edit',
            \ 'parent': submenu })

call NERDTreeAddMenuItem({
            \ 'text': '(r)evert',
            \ 'shortcut': 'r',
            \ 'callback': 'NERDTree_p4revert',
            \ 'parent': submenu })

call NERDTreeAddMenuItem({
            \ 'text': '(a)dd',
            \ 'shortcut': 'a',
            \ 'callback': 'NERDTree_p4add',
            \ 'parent': submenu })

call NERDTreeAddMenuItem({
            \ 'text': '(d)elete',
            \ 'shortcut': 'd',
            \ 'callback': 'NERDTree_p4delete',
            \ 'parent': submenu })

" Functions
function! NERDTree_p4edit()
    let currentNode = g:NERDTreeFileNode.GetSelected()
:   exec '!p4 edit '.shellescape(currentNode.path.str())
    call currentNode.refresh()
    call b:NERDTree.render()
endfunction

function! NERDTree_p4revert()
    let currentNode = g:NERDTreeFileNode.GetSelected()
:   exec '!p4 revert '.shellescape(currentNode.path.str())
    call currentNode.refresh()
    call b:NERDTree.render()
endfunction

function! NERDTree_p4add()
    let currentNode = g:NERDTreeFileNode.GetSelected()
:   exec '!p4 add '.shellescape(currentNode.path.str())
    call currentNode.refresh()
    call b:NERDTree.render()
endfunction

function! NERDTree_p4delete()
    let currentNode = g:NERDTreeFileNode.GetSelected()
:   exec '!p4 delete '.shellescape(currentNode.path.str())
    call currentNode.refresh()
    call b:NERDTree.render()
endfunction

function! NERDTree_perforceEnabled()
    " TODO: Need a fast (instant) way to determine if the the CWD or any parent has a .p4config
    return 1
endfunction
