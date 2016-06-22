" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

function! vimmail#sendmail#Sendmail()
    if !exists("g:VimMailSendCmd")
        let l:cmd=":!mutt -a %"
    else
        let l:cmd=g:VimMailSendCmd
    endif
    execute l:cmd
endfunction

" vim:set et sw=4:
