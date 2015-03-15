" File:        mail.vim
" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.2

"Don't load twice
if exists("g:loaded_VimMail")
    finish
endif
let g:loaded_VimMail=1
" Save context
let s:save_cpo = &cpo
set cpo&vim

"
" Configuration
"

" Go at the end of the headers
if(!exists("g:VimMailStartOnTop"))
    au BufWinEnter *mutt-* call VimMailGoto('^$')
endif

"
" Mappings
"

" Start mutt in RO mode
if !hasmapto("<LocalLeader>M","n")
    map <LocalLeader>M  :call VimMailStartClientRO() <CR>
endif

" Go to different parts of the mail
if !hasmapto("<LocalLeader>f","n")
    map <LocalLeader>f :call VimMailGoto('^From') <CR>
endif

if !hasmapto("<LocalLeader>b","n")
    map <LocalLeader>b :call VimMailGoto('^Bcc') <CR>
endif

if !hasmapto("<LocalLeader>c","n")
    map <LocalLeader>c :call VimMailGoto('^Cc') <CR>
endif

if !hasmapto("<LocalLeader>s","n")
    map <LocalLeader>s :call VimMailGoto('^Subject') <CR>
endif

if !hasmapto("<LocalLeader>R","n")
    map <LocalLeader>R :call VimMailGoto('^Reply-To') <CR>
endif

if !hasmapto("<LocalLeader>t","n")
    map <LocalLeader>t :call VimMailGoto('^To') <CR>
endif

if !hasmapto("<LocalLeader>r","n")
    map <LocalLeader>r :call VimMailGoto('^>') <CR>
endif

if !hasmapto("<LocalLeader>r2","n")
    map <LocalLeader>r2 :call VimMailGoto('^>\s*>') <CR>
endif

if !hasmapto("<LocalLeader>r3","n")
    map <LocalLeader>r3 :call VimMailGoto('^>\s*>\s*>') <CR>
endif

if !hasmapto("<LocalLeader>r4","n")
    map <LocalLeader>r4 :call VimMailGoto('^>\s*>\s*>\s*>') <CR>
endif

if !hasmapto("<LocalLeader>S", "n")
    map <LocalLeader>S :call VimMailGoto('^-- ') <CR>
endif

" pc_query completion
if(!exists("g:VimMailDontUseComplete"))
    if !hasmapto("<LocalLeader>a","i")
        imap <localLeader>a <C-X><C-U>
    endif
    " Completion based on pc_query
    set completefunc=CompleteAddr
endif


"
" Functions
"

" Start the mail client in RO mode
function! VimMailStartClientRO()
    if (!exists("g:VimMailClient"))
        let g:VimMailClient="xterm -e  \"mutt -R\""
    endif
    execute ":! ".g:VimMailClient
endfunction

" Complete function using pc_query
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! CompleteAddr(findstart, base)
    if(a:findstart)
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
    else
        " Set the grep function
        if (g:VimMailCompleteOnlyMail)
            let l:grep="egrep \"(Name|MAIL)\""
        else
            let l:grep="grep :"
        endif
        let l:records=[]
        " Do the query
        let l:query=system("pc_query ".a:base."|".l:grep)
        for line in split(l:query, '\n')
            "Recover the name
            if line=~ "Name"
                let l:name=substitute(split(line, ':')[1],"^[ ]*","","")
            else
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

" Go to a part of the message
function! VimMailGoto(pattern)
    normal gg
    execute "/".a:pattern
    normal A
endfunction;

" Restore context
let &cpo = s:save_cpo
