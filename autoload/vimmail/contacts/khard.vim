" Description: Plugin for writing mail from vim (mutt or others)
" Author:      Ricardo Gonzalez <correoricky@gmail.com>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

if(!has_key(g:VimMailContactsCommands, "khard"))
    let g:VimMailContactsCommands['khard']={ 'query' : "khard email --parsable --search-in-source-files",
                \'sync': "vdirsyncer sync"}
endif

function! vimmail#contacts#khard#sync()
    execute ":! ".g:VimMailContactsCommands['khard']['sync']
endfunction

" Complete function
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! vimmail#contacts#khard#complete(findstart, base)
    if(a:findstart) "first call {{{3
        return vimmail#contacts#startComplete()
    else "Find complete {{{3
        let records=[]
        " Do the query {{{4
        let output=vimmail#runcmd(g:VimMailContactsCommands['khard']['query'].
                    \" ".a:base)
        for line in output
            if line!~ "searching"
                let l:item={}
                let ans=split(line,'\t')
                let l:name=ans[1]
                let l:item.info=l:name.":\n ".line
                let l:item.word=l:name." <".ans[0].">"
                let l:item.abbr=ans[0]
                if len(ans) > 2
                    let l:item.menu=ans[2]
                endif
                let l:item.kind="M"
                call add(records, item)
            endif
        endfor
        return records
    endif
endfunction


" vim:set et sw=4:
