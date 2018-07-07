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

if(!exists('s:scriptdir'))
    let s:scriptdir=expand('<sfile>:h:p')
endif

function! s:CheckContactProvider()
    if(!filereadable(s:scriptdir.'/contacts/'.g:VimMailContactsProvider.'.vim'))
        call vimmail#echo("Unsupported provider : '".g:VimMailContactsProvider."'",
                    \"e")
        return 0
    endif
    return 1
endfunction

function! vimmail#contacts#sync()
    if(!s:CheckContactProvider())
        return
    endif
    call function('vimmail#contacts#'.g:VimMailContactsProvider.'#sync')()
endfunction

" Complete function
function! vimmail#contacts#CompleteAddr(findstart, base)
    if(!s:CheckContactProvider())
        return
    endif
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

function vimmail#contacts#startComplete()
    let line=getline('.')
    " Are we in a header field ?
    if line=~ '^\(From\|To\|Cc\|Bcc\|Reply-To\):'
        let g:VimMailCompleteOnlyMail=1
    else
        let g:VimMailCompleteOnlyMail=0
    endif
    " Find the start
    let start=col('.')-1
    while start > 0 && line[start - 1] =~ '\a'
        let start -= 1
    endwhile
    return start
endfunction

" vim:set et sw=4:
