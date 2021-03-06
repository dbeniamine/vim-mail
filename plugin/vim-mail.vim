" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

"Don't load twice {{{1
if exists("g:loaded_VimMail")
    finish
endif
" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

let g:VimMailDirectory=expand('<sfile>:p:h')."/.."

" Toggle spelllang
if !exists("g:VimMailDoNotMap")
    noremap <LocalLeader>l :call vimmail#spelllang#SwitchSpellLangs()<CR>
    noremap <LocalLeader>m :call vimmail#sendmail#Sendmail()<CR>
endif

" Restore context {{{1
let &cpo = s:save_cpo

" vim:set et sw=4:
