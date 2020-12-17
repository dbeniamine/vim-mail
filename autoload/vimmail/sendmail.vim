" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

function! vimmail#sendmail#Sendmail()
    if exists("g:VimMailSendCmd")
        let l:cmd=g:VimMailSendCmd
    else
        if executable("neomutt")
            let l:cmd=":!neomutt -a %"
        elseif executable("mutt")
            let l:cmd=":!mutt -a %"
        else
            echoerr "No mutt, neomutt or custom g:VimMailSendCmd found."
            return
        endif
    endif
    execute l:cmd
endfunction

" vim:set et sw=4:
