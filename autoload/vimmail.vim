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
