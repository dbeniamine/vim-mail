" File:        mail.vim
" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.2.2

" Don't load twice {{{1
if exists("g:loaded_VimMail")
    finish
endif
let g:loaded_VimMail=1

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" Configuration {{{1

" Go at the end of the headers {{{2
if(!exists("g:VimMailStartOnTop"))
    au BufWinEnter *mutt-* call VimMailGoto('^$','I')
endif

" Set fold method {{{2
if(!exists("g:VimMailDoNotFold"))
    setlocal foldexpr=VimMaiFoldLevel() foldmethod=expr
endif

" Mappings {{{1

" Start mutt in RO mode {{{2
if !hasmapto("<LocalLeader>M","n")
    map <LocalLeader>M  :call VimMailStartClientRO() <CR>
endif

" Go to different parts of the mail {{{2
if !hasmapto("<LocalLeader>f","n")
    map <LocalLeader>f :call VimMailGoto('^From','A') <CR>
endif

if !hasmapto("<LocalLeader>b","n")
    map <LocalLeader>b :call VimMailGoto('^Bcc','A') <CR>
endif

if !hasmapto("<LocalLeader>c","n")
    map <LocalLeader>c :call VimMailGoto('^Cc','A') <CR>
endif

if !hasmapto("<LocalLeader>s","n")
    map <LocalLeader>s :call VimMailGoto('^Subject','A') <CR>
endif

if !hasmapto("<LocalLeader>R","n")
    map <LocalLeader>R :call VimMailGoto('^Reply-To','A') <CR>
endif

if !hasmapto("<LocalLeader>t","n")
    map <LocalLeader>t :call VimMailGoto('^To','A') <CR>
endif

if !hasmapto("<LocalLeader>r","n")
    map <LocalLeader>r :call VimMailGoto('^>','I') <CR>
endif

if !hasmapto("<LocalLeader>r2","n")
    map <LocalLeader>r2 :call VimMailGoto('^>\s*>','I') <CR>
endif

if !hasmapto("<LocalLeader>r3","n")
    map <LocalLeader>r3 :call VimMailGoto('^>\s*>\s*>','I') <CR>
endif

if !hasmapto("<LocalLeader>r4","n")
    map <LocalLeader>r4 :call VimMailGoto('^>\s*>\s*>\s*>','I') <CR>
endif

if !hasmapto("<LocalLeader>S", "n")
    map <LocalLeader>S :call VimMailGoto('^-- ','j') <CR>
endif

if !hasmapto("<LocalLeader>B", "n")
    map <LocalLeader>B :call VimMailGoto('^$','I') <CR>
endif

if !hasmapto("<LocalLeader>E", "n")
    map <LocalLeader>E :call VimMailGoto('^>','Nj') <CR>
endif


" pc_query completion {{{2
if(!exists("g:VimMailDontUseComplete"))
    if !hasmapto("<LocalLeader>a","i")
        imap <localLeader>a <C-X><C-O>
    endif
    if(!exists("g:VimMailContactSyncCmd"))
        let g:VimMailContactSyncCmd="pycardsyncer"
    endif
    if(!exists("g:VimMailContactQueryCmd"))
        let g:VimMailContactQueryCmd="pc_query"
    endif
    if !hasmapto("<LocalLeader>a","n")
        nmap <localLeader>a :execute ":! ".g:VimMailContactSyncCmd<CR>
    endif
    " Contact completion
    set omnifunc=CompleteAddr
endif


" Functions {{{1

" Start the mail client in RO mode {{{2
function! VimMailStartClientRO()
    if (!exists("g:VimMailClient"))
        let g:VimMailClient="xterm -e  \"mutt -R\""
    endif
    execute ":! ".g:VimMailClient
endfunction

" Complete function {{{2
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! CompleteAddr(findstart, base)
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

" Go to a part of the message {{{2
function! VimMailGoto(pattern,post)
    normal gg
    execute "/".a:pattern
    execute "normal ".a:post
endfunction;

" Fold Method {{{2
function! VimMaiFoldLevel()
    let l:line = matchstr(getline(v:lnum),'^>[> ]*')
    if !empty(l:line)
        return len(substitute(l:line,' ',"","g"))
    else
        return 0
    endif
endfunction

" Restore context {{{1
let &cpo = s:save_cpo
