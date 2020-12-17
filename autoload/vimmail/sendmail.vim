" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

function! vimmail#sendmail#Sendmail()
    if exists("g:VimMailSendCmd")
        let l:cmd=g:VimMailSendCmd
    else
        if executable("neomutt")
            let l:mailerbin="neomutt"
        elseif executable("mutt")
            let l:mailerbin="mutt"
        else
            echoerr "No mutt, neomutt or custom g:VimMailSendCmd found."
            return
        endif

        let l:cmd=":!" . l:mailerbin . " -a %"
    endif
    execute l:cmd
endfunction

" vim:set et sw=4:
