" File:        vim-mail.vim
" Description: Filetype detection for mutt mail and muttiles
" Author:      David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/vim-mail.vim
" Version:     0.1

" Detect mail files
augroup filetypedetect
    " Mail
    autocmd BufEnter *mutt-* setfiletype mail
    "mutt files
    autocmd BufEnter *.mutt setfiletype muttrc
augroup END
