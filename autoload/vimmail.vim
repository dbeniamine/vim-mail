if(!exists("g:VimMailSpellLangs"))
    let g:VimMailSpellLangs=['fr','en']
endif

function! vimmail#SwitchSpellLangs()
    if &spell==0
        let l:index=0
        set spell
    else
        let l:curlang=index(g:VimMailSpellLangs,&spelllang)
        if l:curlang == len(g:VimMailSpellLangs)-1
            set nospell
            echo "Spell disabled"
            return
        endif
        let l:index=l:curlang+1
    endif
    let l:nlang=get(g:VimMailSpellLangs,l:index)
    echo "Setting spelllang: ".l:nlang
    let &spelllang=l:nlang
endfunction

function! vimmail#Sendmail()
    if !exists("g:VimMailSendCmd")
        let l:cmd=":!mutt -a %"
    else
        let l:cmd=g:VimMailSendCmd
    endif
    execute l:cmd
endfunction

" pc_query completion
if(!exists("g:VimMailDontUseComplete"))
    if(!exists("g:VimMailContactSyncCmd"))
        let g:VimMailContactSyncCmd="pycardsyncer"
    endif
    if(!exists("g:VimMailContactQueryCmd"))
        let g:VimMailContactQueryCmd="pc_query"
    endif
    if !exists("g:VimMailDoNotMap")
        imap <silent><localLeader>a <C-X><C-O>
        nmap <silent><localLeader>a :execute ":! ".g:VimMailContactSyncCmd<CR>
    endif
    " Contact completion
    set omnifunc=vimmail#CompleteAddr
endif

" Complete function
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! vimmail#CompleteAddr(findstart, base)
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
        let l:records=[]
        " Do the query {{{4
        let l:query=system(g:VimMailContactQueryCmd." ".a:base."|".l:grep)
        for line in split(l:query, '\n')
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
        if(! exists("g:VimMailDoNotAppendQueryToResults"))
            " Append the query to the records
            let l:item={}
            let l:item.word=a:base
            let l:item.kind='Q'
            let l:item.info="query: ".a:base
            call add(records, item)
        endif
        return records
    endif
endfunction


