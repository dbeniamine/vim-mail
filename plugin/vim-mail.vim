" File:        vim-mail.vim
" Description: Easy Spelllang switcher
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.1

let s:save_cpo = &cpo
set cpo&vim

" Toggle spelllang
if !hasmapto("<LocalLeader>l",'n')
    noremap <LocalLeader>l :call SwitchSpellLangs()<CR>
endif

if(!exists("g:VimMailSpellLangs"))
    let g:VimMailSpellLangs=['fr','en']
endif


" Switch between spellangs
function! SwitchSpellLangs()
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

let &cpo = s:save_cpo
