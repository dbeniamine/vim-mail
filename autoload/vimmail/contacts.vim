" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if(!exists("g:VimMailContactsProvider"))
    let g:VimMailContactsProvider = ["pc_query"]
endif

try
    call join(g:VimMailContactsProvider, ' ')
catch /^Vim\%((\a\+)\)\=:E714/
    " Retro compatibility
    let g:VimMailContactsProvider = [g:VimMailContactsProvider]
endtry


if(!exists("g:VimMailContactsCommands"))
    let g:VimMailContactsCommands = {}
endif

if(!exists('s:scriptdir'))
    let s:scriptdir=expand('<sfile>:h:p')
endif

function! s:CheckContactProvider(provider)
    if(!filereadable(s:scriptdir.'/contacts/'.a:provider.'.vim'))
        call vimmail#echo("Unsupported provider : '".a:provider."'",
                    \"e")
        return 0
    endif
    return 1
endfunction

function! vimmail#contacts#sync()
    for provider in g:VimMailContactsProvider
        if(s:CheckContactProvider(provider))
            call function('vimmail#contacts#'.provider.'#sync')()
        endif
    endfor
endfunction

" Complete function
function! vimmail#contacts#CompleteAddr(findstart, base)
    if(a:findstart) "first call {{{3
        return vimmail#contacts#startComplete()
    else "Find complete {{{3
        let records=[]
        let records_dic = {}
        for provider in g:VimMailContactsProvider
            if(s:CheckContactProvider(provider))
                let sub_records = function('vimmail#contacts#'.provider.'#complete')
                        \(a:findstart, a:base)
                for rec in sub_records
                    if(!has_key(records_dic, rec.word))
                        let records_dic[rec.word]=1
                        let rec.info.="\nProvider: ".provider
                        call add(records, rec)
                    endif
                endfor
            endif
        endfor
        if(!a:findstart && ! exists("g:VimMailDoNotAppendQueryToResults"))
            " Append the query to the records
            let l:item={}
            let l:item.word=a:base
            let l:item.kind='Q'
            let l:item.info="query: ".a:base
            call add(records, item)
        endif
        " TODO : remove duplicates
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
