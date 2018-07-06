" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if(!has_key(g:VimMailContactsCommands, "pc_query"))
    let g:VimMailContactsCommands['pc_query']={ 'query' : "pc_query",
                \'sync': "pycardsyncer"}
endif

function! vimmail#contacts#pc_query#sync()
    execute ":! ".g:VimMailContactsCommands['pc_query']['sync']
endfunction

" Complete function
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! vimmail#contacts#pc_query#complete(findstart, base)
    if(a:findstart) "first call {{{3
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
    else "Find complete {{{3
        " Set the grep function {{{4
        if (g:VimMailCompleteOnlyMail)
            let l:grep="egrep \"(Name|MAIL)\""
        else
            let l:grep="grep :"
        endif
        let records=[]
        " Do the query {{{4
        let out=vimmail#runcmd(g:VimMailContactsCommands['pc_query']['query'].
                    \" ".a:base." | ".l:grep)
        for line in out
            if line=~ "Name" "Recover the name {{{5
                let l:name=substitute(split(line, ':')[1],"^[ ]*","","")
            else " parse the answer {{{5
                " pc_query answer look like this
                " EMAIL (WORK): foo@bar.com
                let ans=split(line,':')
                " Remove useless whitespace
                let ans[1]=substitute(ans[1], "^[ ]*","","")
                let l:item={}
                " Full information for preview window name + pc_query line
                let l:item.info=l:name.":\n ".line
                if ans[0]=~"^EMAIL"
                    " Put email addresses in '<' '>'
                    let l:item.word=l:name." <".ans[1].">"
                    let l:item.abbr=ans[1]
                    let l:item.kind="M"
                else
                    let l:item.word=ans[1]
                    "Use the first letter of the pc_query type for the kind
                    let l:item.kind=strpart(ans[0],0,1)
                endif
                " If there are a precise info (aka '(WORK)') add it
                if ans[0]=~"(.*)"
                    let l:item.menu=substitute(ans[0],'\(.*(\|).*\)',"","g")
                endif
                call add(records, item)
            endif
        endfor
        return records
    endif
endfunction


" vim:set et sw=4:
