" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

" Assigns arguments to the mail program depending on the filetype of the
" buffer.
if !exists("g:VimMailArgsByFiletype")
    let g:VimMailArgsByFiletype={"mail" : "-H"}
endif
if !exists("g:VimMailArgsDefault")
    let g:VimMailArgsDefault="-a"
endif

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

        " If there are filetype specific settings, use them, otherwise use the
        " default.
        if has_key(g:VimMailArgsByFiletype, &filetype)
            let l:mailerarg=g:VimMailArgsByFiletype[&filetype]
        else
            let l:mailerarg=g:VimMailArgsDefault
        endif

        let l:cmd=":!" . l:mailerbin . " " . l:mailerarg . " %"
    endif
    execute l:cmd
endfunction

" vim:set et sw=4:
