set nocompatible

let g:script_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
execute 'source' script_dir . '/utils.vim'

call utils#SourceInitScript('mappings')
call utils#SourceInitScript('plugins')
call utils#SourceInitScript('settings')
call utils#SourceInitScript('theme')
