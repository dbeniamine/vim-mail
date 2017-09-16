" Description: Plugin for writing mail from vim (mutt or others)
" Author:      David Beniamine <David@Beniamine.net>
" License:     Gpl v3.0
" Website:     http://github.com/dbeniamine/vim-mail.vim

" Don't load twice {{{1
if exists("g:loaded_VimMail")
    finish
endif
let g:loaded_VimMail=0.2.6

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" Go to a part of the message {{{2
function! VimMailGoto(pattern,post)
    normal gg
    if a:pattern != ''
        execute a:pattern
    endif
    if a:post != ''
        execute "normal ".a:post
    endif
endfunction

function! VimMailKillQuotedSig()
    normal! gg
    try
        " Look for first quoted sig
        /^ *>[> ]* -- *$/
    catch
        " No quoted sig get out
        return
    endtry
    try
        " Remove everything until our signature
        execute "normal! d/^-- $/\<CR>"
    catch
        " Oups we don't have a signature => remove untill the next empty line
        execute "normal! d}"
    endtry
endfunction

" Configuration {{{1

" Set start position {{{2
" Start flags:
"   i : insert mode
"   o : Add new line after cursor
"   O : Add new line before cursor
"   A : Place cursor at the end of the line
"   W : Start on second word (a.k.a first address of field / word of subject)
"   I : Intelligent start: If two replies, start above on below, as the last
"       replier, else default to other flags
"   t : top (Right after headers)
"   b : Bottom (After last message)
"   F : From field
"   T : To field
"   C : Cc field
"   B : Bcc field
"   S : Subject field
"   r : Remove quoted signatures
if !exists("g:VimMailStartFlags")
    let g:VimMailStartFlags="toi"
endif

" Start position {{{2
" Remove quoted signatures
if g:VimMailStartFlags =~ "r"
    call VimMailKillQuotedSig()
endif

" Start mode
if g:VimMailStartFlags =~ "o"
    let s:StartMode='o'
elseif g:VimMailStartFlags =~ "O"
    let s:StartMode='O'
elseif g:VimMailStartFlags =~ "A"
    let s:StartMode='A'
elseif g:VimMailStartFlags =~ "W"
    let s:StartMode='W'
else
    let s:StartMode=''
endif

function IntelligentStartPos()
    call search('^>[ ]*\(Le\|On\).*:','e')
    let rep1=search('^>[ ]*[^ >]','W')
    let rep2=search('^>[ ]*>','W')
    if rep1 == 0 || rep2 ==0
        return 0
    endif
    return rep2-rep1
endfunction

function StartTop()
    let s:StartPos='/^$'
endfunction

function StartBottom()
    if search('^--') != 0
        let s:StartPos='/^--'
        let s:StartMode='k'.s:StartMode
    else
        let s:StartPos=''
        let s:StartMode='G'.s:StartMode
    endif
endfunction

" Start pattern
let pos=IntelligentStartPos()
if g:VimMailStartFlags =~ "I" && pos !=0
    if pos > 0
        call StartTop()
    else
        call StartBottom()
    endif
elseif g:VimMailStartFlags =~ "t"
        call StartTop()
elseif g:VimMailStartFlags =~ "b"
    call StartBottom()
elseif g:VimMailStartFlags =~ "F"
    let s:StartPos='/^From'
elseif g:VimMailStartFlags =~ "T"
    let s:StartPos='/^To'
elseif g:VimMailStartFlags =~ "C"
    let s:StartPos='/^Cc'
elseif g:VimMailStartFlags =~ "B"
    let s:StartPos='/^Bcc'
elseif g:VimMailStartFlags =~ "S"
    let s:StartPos='/^Subject'
endif

" Place cursor
" Insert mode
let cmd='au BufWinEnter *mutt-* call VimMailGoto(s:StartPos,s:StartMode)'
if g:VimMailStartFlags =~ "i"
    let cmd.=' | :start'
endif
execute cmd

" Set fold method {{{2
if(!exists("g:VimMailDoNotFold"))
    setlocal foldexpr=VimMaiFoldLevel() foldmethod=expr
endif

" Mappings {{{1

" Start mutt in RO mode {{{2
if !exists("g:VimMailDoNotMap")
    map <silent><LocalLeader>M  :call VimMailStartClientRO() <CR>

" Go to different parts of the mail {{{2
    map <silent><LocalLeader>f :call VimMailGoto('/^From','A') <CR>
    map <silent><LocalLeader>b :call VimMailGoto('/^Bcc','A') <CR>
    map <silent><LocalLeader>c :call VimMailGoto('/^Cc','A') <CR>
    map <silent><LocalLeader>s :call VimMailGoto('/^Subject','A') <CR>
    map <silent><LocalLeader>R :call VimMailGoto('/^Reply-To','A') <CR>
    map <silent><LocalLeader>t :call VimMailGoto('/^To','A') <CR>
    map <silent><LocalLeader>r :call VimMailGoto('/^>','I') <CR>
    map <silent><LocalLeader>r2 :call VimMailGoto('/^>\s*>','I') <CR>
    map <silent><LocalLeader>r3 :call VimMailGoto('/^>\s*>\s*>','I') <CR>
    map <silent><LocalLeader>r4 :call VimMailGoto('/^>\s*>\s*>\s*>','I') <CR>
    map <silent><LocalLeader>S :call VimMailGoto('/^-- ','j') <CR>
    map <silent><LocalLeader>B :call VimMailGoto('/^$','I') <CR>
    map <silent><LocalLeader>E :call VimMailGoto('/^>','Nj') <CR>
    map <silent><LocalLeader>kqs :call VimMailKillQuotedSig() <CR>
endif




" Functions {{{1

" Start the mail client in RO mode {{{2
function! VimMailStartClientRO()
    if (!exists("g:VimMailClient"))
        let g:VimMailClient="xterm -e  'mutt -R'"
    endif
    execute ":silent !".g:VimMailClient
endfunction

" Fold Method {{{2
function! VimMaiFoldLevel()
    let l:line = matchstr(getline(v:lnum),'^>[> ]*')
    if !empty(l:line)
        return len(substitute(l:line,' ',"","g"))
    else
        return 0
    endif
endfunction

" pc_query completion {{{2
if(!exists("g:VimMailDontUseComplete"))
    if !exists("g:VimMailDoNotMap")
        imap <silent><localLeader>a <C-X><C-O>
        nmap <silent><localLeader>a :execute ":! ".g:VimMailContactSyncCmd<CR>
    endif
    " Contact completion
    set omnifunc=vimmail#completion#CompleteAddr
endif

" Restore context {{{1
let &cpo = s:save_cpo

" vim:set et sw=4:
