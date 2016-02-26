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


