" File:        vim-mail.vim
" Description: Easy Spelllang switcher
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.1

"Don't load twice {{{1
if exists("g:loaded_VimMail")
    finish
endif
" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" Configuration {{{1

if(!exists("g:VimMailSpellLangs"))
    let g:VimMailSpellLangs=['fr','en']
endif


" Mappings {{{1

" Toggle spelllang {{{2
if !hasmapto("<LocalLeader>l",'n')
    noremap <LocalLeader>l :call SwitchSpellLangs()<CR>
endif

" Functions {{{1

" Switch between spellangs {{{2
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

" Restore context {{{1
let &cpo = s:save_cpo
