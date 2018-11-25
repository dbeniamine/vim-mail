" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if(!has_key(g:VimMailContactsCommands, "mu"))
    let g:VimMailContactsCommands['mu']={ 'query' : "mu cfind",
                \'sync': "mu index",
                \'config': {
                \'default': {
                \'home': '$HOME/mu',
                \'maildir': '$HOME/mail',
                \}
                \}
                \}
endif

" Returns from address
function s:getFromAddr()
    return substitute(split(getline(search('^From:', 'n')),' ')[-1],
                \'[<>]', '', 'g')
endfunction

" Return mu directories from config
function s:getMuDir(type)
    let from=s:getFromAddr()
    let account='default'
    if(has_key(g:VimMailContactsCommands['mu']['config'], from))
        let account=from
    endif
    return g:VimMailContactsCommands['mu']['config'][account][a:type]
endfunction

" Return mu configstring
function s:getConfigString(type)
    let ret =' --muhome='.s:getMuDir('home')
    if(a:type == 'sync')
        let ret.=' --maildir='.s:getMuDir('maildir')
    endif
    return ret
endfunction

function! vimmail#contacts#mu#sync()
    execute ":! ".g:VimMailContactsCommands['mu']['sync'].getConfigString('sync')
endfunction

" Complete function
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! vimmail#contacts#mu#complete(findstart, base)
    if(a:findstart) "first call {{{3
        return vimmail#contacts#startComplete()
    else "Find complete {{{3
        let records=[]
        " Do the query {{{4
        let output=vimmail#runcmd(g:VimMailContactsCommands['mu']['query'].
                    \' --nocolor '.s:getConfigString('find').' '.a:base)
        for line in output
            let ans=split(line, ' ')
            let l:item={}
            if (len(ans) > 1)
                let l:item.info=join(ans[0:len(ans)-2], ' ')
                let l:item.word=l:item.info.' <'.ans[-1].'>'
            else
                let l:item.info=ans[0]
                let l:item.word=ans[0]
            endif
            let l:item.kind="M"
            call add(records, item)
        endfor
        return records
    endif
endfunction


" vim:set et sw=4:
