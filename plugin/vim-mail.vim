" File:        vim-mail.vim
" Description: Easy Spelllang switcher
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.1

"Don't load twice {{{1
if exists("g:loaded_VimMail")
    finish
endif
" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim


" Toggle spelllang
if !hasmapto("<LocalLeader>l",'n')
    noremap <LocalLeader>l :call vimmail#SwitchSpellLangs()<CR>
endif

" Restore context {{{1
let &cpo = s:save_cpo
