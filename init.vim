set nocompatible

if has('win32')
    let g:python3_host_prog='C:/Python37/python.exe'
    let g:python_host_prog='C:/Python27/python.exe'
endif

call utils#Init('mappings')
call utils#Init('plugins')
call utils#Init('settings')
call utils#Init('theme')
