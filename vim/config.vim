" This file defines variables which tweak behaviour of vimrc without
" modifying the vimrc itself

" These options enable/disable plugins completely
let g:vimrc_easymotion_enabled=1
let g:vimrc_easyescape_enabled=1
let g:vimrc_bufexplorer_enabled=1
let g:vimrc_gruvbox_enabled=1
let g:vimrc_airline_enabled=1
let g:vimrc_airline_themes_enabled=0
let g:vimrc_nerdtree_enabled=1
let g:vimrc_ctrlp_enabled=0
let g:vimrc_ycm_enabled=0

" These options tweak some part of plugin behaviour, if plugin is enabled.
" Otherwise, they have no effect
let g:vimrc_gruvbox_background='dark' " 'dark' / 'light'
let g:vimrc_airline_whitespace_checks='all' " 'none' / 'trailing' / 'all'
let g:vimrc_ycm_enable_g_mappings=1
let g:vimrc_ycm_enable_auto_trigger=0
let g:vimrc_ycm_enable_signature_help=0
