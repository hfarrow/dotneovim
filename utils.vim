let s:debug = 0

function! utils#Debug(msg)  " {{{
    if s:debug == 1
        echom "[debug]" a:msg
    endif
endfunction " }}}

function! utils#Source(file) " {{{
    let expandedFile = expand(a:file)
    if filereadable(expandedFile)
        call utils#Debug('Sourcing source: ' . a:file . ' (' . expandedFile . ')')
        exec ':source ' . expandedFile
    else
        let path = expand(utils#MakePath(a:file))
        if filereadable(path)
            call utils#Debug('Sourcing :source ' . a:file . ' (' . path . ')')
            exec ':source ' . path
        else
            call utils#Debug('Sourcing :runtime ' . a:file . ' (' . a:file . ')')
            exec ':runtime ' . a:file
        endif
    endif
endfunction " }}}

function! utils#SourceInitScript(path)
    let file = 'init_' . a:path . '.vim'
    call utils#Source(file)
endfunction

function! utils#ConfigurePlugins(path)
    let basePath = g:script_dir . '/' . a:path
    call utils#Debug('base plugin path: '. basePath)
    for file in split(glob(basePath . '*.vim'), '\n')
        call utils#Source(file)
    endfor
endfunction

function! utils#MakePath(path) " {{{
    if match(a:path, '/') == 0
        string.sub(a:path, 1)
    endif
    let ret = g:script_dir . '/' . a:path
    return ret
endfunction " }}}

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

