let s:debug = 0

let g:nvim_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:nvim_dir = resolve(g:nvim_dir . '/..')

function! utils#Debug(msg)  " {{{
    if s:debug == 1
        echom "[debug]" a:msg
    endif
endfunction " }}}

function! utils#Init(module) " {{{
    let script = 'init_' . a:module . '.vim'
    call utils#Debug(script)
    execute ':runtime ' . script
endfunction " }}}

function! utils#ConfigurePlugins(path)
    let basePath = g:nvim_dir . '/' . a:path
    call utils#Debug('base plugin path: '. basePath)
    execute ':set runtimepath+=' . basePath
    for file in split(glob(basePath . '*.vim'), '\n')
        let filename = fnamemodify(file, ':t')
        call utils#Debug('Configure plugin: ' . filename)
        execute 'runtime ' . filename
    endfor
endfunction

function! utils#EnsureExists(path) " {{{
    call utils#Debug('Ensure directory exists: ' . expand(a:path))
    if filereadable(expand(a:path))
        call utils#Debug('Cannot ensure directory "' . expand(a:path) . '" exists becuase it is a file.')
    elseif !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
endfunction " }}}

function! CloseWindowOrKillBuffer() " {{{
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    " never bdelete a NERDTree
    if matchstr(expand("%"), 'NERD') == 'NERD'
        wincmd c
        return
    endif

    if number_of_windows_to_this_buffer > 1
        wincmd c
    else
        bdelete
    endif
endfunction " }}}

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}

