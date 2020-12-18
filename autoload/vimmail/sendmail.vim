" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if exists("g:VimMailSendCmd")
    echo "Deprecated g:VimMailSendCmd set. Use g:VimMailBin and friends instead."
endif

if !exists("g:VimMailBin")
    if executable("neomutt")
        let g:VimMailBin="neomutt"
    elseif executable("mutt")
        let g:VimMailBin="mutt"
    else
        echoerr "No g:VimMailBin set and no neomutt or mutt found."
    endif
endif

" Assigns arguments to the mail program depending on the filetype of the
" buffer.
if !exists("g:VimMailArgsByFiletype")
    let g:VimMailArgsByFiletype={"mail" : "-H %"}
endif
if !exists("g:VimMailArgsDefault")
    let g:VimMailArgsDefault="-a %"
endif

function! vimmail#sendmail#Sendmail()
    if !exists("g:VimMailBin")
        echoerr "No g:VimMailBin set."
        return
    endif

    " If there are filetype specific settings, use them, otherwise use the
    " default.
    if has_key(g:VimMailArgsByFiletype, &filetype)
        let l:mailerarg=g:VimMailArgsByFiletype[&filetype]
    else
        let l:mailerarg=g:VimMailArgsDefault
    endif

    if has('nvim') || has ('gui_running')
        " A difference between neovim and vim is that :! does not support
        " interactive commands and this is leads to a complaint of
        " (neo)mutt of not sending empty mails.
        " Although the reasons differ, also gvim has troubles running mutt
        " within itself using the bang command.
        let l:cmdprefix=":terminal "
    else
        let l:cmdprefix=":!"
    endif

    let l:cmd=l:cmdprefix . g:VimMailBin . " " . expand(l:mailerarg)
    execute l:cmd
endfunction

" vim:set et sw=4:
