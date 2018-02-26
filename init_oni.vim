if exists("g:gui_oni")
    " Oni specific: Remove status bar because Oni has one built into the UI.
    set noshowmode
    set noruler
    echom 'set laststatus=0'
    set laststatus=0
    set noshowcmd

    " Remove unnamedplus (system clipboard) because it conflicts with Oni's built-in system clipboard integration.
    set clipboard-=unnamedplus
endif
