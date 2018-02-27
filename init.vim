set nocompatible

" TODO: Use autoload plugin for utils
let g:script_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
execute 'source' script_dir . '/utils.vim'

" TODO: Use runtime init_xxx.vim instead of source and get rid of source util functions
call utils#SourceInitScript('mappings')
call utils#SourceInitScript('plugins')
call utils#SourceInitScript('settings')
call utils#SourceInitScript('theme')
