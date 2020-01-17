" Neovim-Qt
if exists('g:GuiLoaded') && !exists('g:vscode')
    if has('win32')
        GuiFont Consolas:h13
    else
        GuiFont Menlo:h13
    endif
endif
