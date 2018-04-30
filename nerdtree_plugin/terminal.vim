if exists("g:loaded_nerdtree_terminal")
    finish
endif
let g:loaded_nerdtree_terminal = 1

call NERDTreeAddMenuItem({
            \ 'text': '(t)erminal',
            \ 'shortcut': 't',
            \ 'callback': 'NERDTree_terminal'})

function! NERDTree_terminal()
    let currentNode = g:NERDTreeFileNode.GetSelected()
    :exec 'vnew | call termopen("cd '.currentNode.path.str().'&& bash") | startinsert'
endfunction
