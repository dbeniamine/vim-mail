" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

" Prompt {{{1

" Should be used for every messages
" Type can be:
"   e for error
"   w for warning
"   q for asking a question
"   s to tell the user Vizardry is doing something (searching for instance)
"   D to print only in debug mode
" If extra argument is >0, then return the user answer
function! vimmail#echo(msg,type,...)
  let ret=''
  if a:type=='e'
    let group='ErrorMsg'
  elseif a:type=='w'
    let group='WarningMsg'
  elseif a:type=='q'
    let group='Question'
  elseif a:type=='s'
    let group='Define'
  elseif a:type=='D'
    if !exists("g:VizardryDebug")
      return
    else
      let group='WarningMsg'
    endif
  else
    let group='Normal'
  endif
  execute 'echohl '.group
  if a:0 > 0 && a:1 > 0
    let ret=input(a:msg)
  else
    echo a:msg
  endif
  echohl None
  return ret
endfunction

function! vimmail#switchFrom()
 
    let fromLine=search('^From:', 'cn')
    let curFrom = substitute(getline(fromLine), '^From:\s*\(.*\)\s*$', '\1', '')

    " Generate contact list from addressbook
    if(!exists("g:VimMailFromList"))
        let g:VimMailFromList = []
        let g:VimMailCompleteOnlyMail =1
        if(exists("g:VimMailFromContact"))
            let contact=g:VimMailFromContact
        else
            let contact=system('getent passwd `whoami` | cut -d ":" -f 5 | cut -d "," -f 1 | tr -d "\n"')
        endif
        let contacts = vimmail#contacts#CompleteAddr(0, "'".contact."'")
        for entry in contacts
            if entry.kind != 'Q'
                let g:VimMailFromList += [entry.word]
            endif
        endfor
    endif

    let newPos = (index(g:VimMailFromList, curFrom)+1)%len(g:VimMailFromList)
    let newFrom = g:VimMailFromList[newPos]

    let oldPos=getcurpos()
    execute ":".fromLine."s/".curFrom."/".newFrom."/"
    call setpos('.', oldPos)
endfunction

function! vimmail#runcmd(cmd)
    let out=systemlist(a:cmd)
    if(v:shell_error==0)
        return out
    else
        call vimmail#echo(join(out, '\n'), 'e')
        " Let the user see the error
        sleep 1
        return []
    endif
endfunction


" vim:set et sw=4:
