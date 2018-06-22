" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if(!exists("g:VimMailContactsProvider"))
    let g:VimMailContactsProvider = "pc_query"
endif


if(!exists("g:VimMailContactsCommands"))
    let g:VimMailContactsCommands = {}
endif

function! vimmail#contacts#sync()
    call function('vimmail#contacts#'.g:VimMailContactsProvider.'#sync')()
endfunction

" Complete function
function! vimmail#contacts#CompleteAddr(findstart, base)
    let records=function('vimmail#contacts#'.g:VimMailContactsProvider.'#complete')
                \(a:findstart, a:base)
    if(!a:findstart && ! exists("g:VimMailDoNotAppendQueryToResults"))
        " Append the query to the records
        let l:item={}
        let l:item.word=a:base
        let l:item.kind='Q'
        let l:item.info="query: ".a:base
        call add(records, item)
    endif
    return records
endfunction


" vim:set et sw=4:
