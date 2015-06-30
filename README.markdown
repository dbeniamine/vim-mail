# Readme

## What is this plugin ?

This plugin is a small helper for writing mail from vim, I designed it using
mutt but it should work with other clients. I recommend to use it in
combination with [CheckAttach](https://github.com/chrisbra/CheckAttach).


## Install

### Quick install

    git clone https://github.com/dbeniamine/vim-mail.git
    cd vim-mail/
    cp -r ./* ~/.vim

### Pathogen install

    git clone https://github.com/dbeniamine/vim-mail.git ~/.vim/bundle/vim-mail

## Features

This plugin provides the following features

### Contact completion

The contact completion is designed for
[pycarddav](https://pypi.python.org/pypi/pyCardDAV), however it is possible to
use any external tools by setting the following variables:

    let g:VimMailContactSyncCmd="my_synchronisation_cmd"
    let g:VimMailContactQueryCmd="my_query_cmd"

The only restriction is that the query command should give an output similar
to pc_query output, aka something like:

    Name: Someone
    Tel (CELL): 000000000
    EMAIL : someone@foo.bar
    Name: Someone else
    TEL: 0000000
    EMAIL (Work): Someone.else@work.com
    EMAIL (Perso): Someone.else@dummyprovider.com

The fields between parentheses are optional.

You can search your  address book from vim using the following commands:

In insert mode, type:

    <LocalLeader>a

or

    <C-X><C-O>

It will search for the word under the cursor in your contact list.

If you are currently in a From,To,CC or Bcc line, only mail addresses will
be proposed, else all the match will appear. More details will appear in
the preview window including contact name, type of the entry (mail, cell,
phone etc.). To enable to preview window on completion, add to your vimrc:

    set completeopt=preview

To synchronise your address book, in normal mode, type:

    <LocalLeader>a


If you don't want this completion you can either not use the plugin or add
the following line to your vimrc:

    let g:VimMailDontUseComplete=1

By default, the contact completion appends the query to the result list, you
can disable this feature:

    let g:VimMailDoNotAppendQueryToResults

### Redaction

+   **Easy spelllang switch**

    While writing mails, I often need to do switch the spell lang which can be
    annoying, so this plugin provide an easy way to do it. Just type:

        <LocalLeader>l

    and the plugin will switch the spelllang using a list of allowed languages.  
    If the current spellang is the last allowed, it will disable spell, hit

        <LocalLeader>l

    once more and you will restart with the first lang.
    You can set the list of allowed langs in your vimrc:

        let g:VimSpellLangs=['fr', 'en', 'sp']

    The default allowed langs are  french, english
    This will work for any filetype as it can be usefull for many other kind of
    files.

+   Start at the end of the headers

    If you use the edit_headers option from mutt (which I recommend), you have
    to put your cursor manually at the end of the headers before writing your
    mail. This script will automatically put your cursor at the first empty
    line of the file.

    If you don't like that add the following to your vimrc:

        let g:VimMailStartOnTop=1

+   Messages folds

    A folding method which allows you to open are close the messages of the
    conversation is provided.

    If you do not want to use it, add the following line to your vimrc:

        let g:VimMailDoNotFold=1

### Quick in-mail navigation

With this plugin, you can easily navigate through the different par of the
mail using the following commands:

+   **Headers**

    Go to the From field:

        <LocalLeader>f

    Go to the Bcc field:

        <LocalLeader>b

    Go to the Cc field:

        <LocalLeader>c

    Go to the SUbject field:

        <LocalLeader>s

    Go to the Reply-To field:

        <LocalLeader>R

    Go to the Reply-To field:

        <LocalLeader>t

+   **Conversation**

    Go to the first line (after headers):

        <LocalLeader>B

    Go to the first line after the conversation:

        <LocalLeader>E

    Go to the first message of the conversation:

        <LocalLeader>r

    Go to the second message of the conversation:

        <LocalLeader>r2

    Go to the third message of the conversation:

        <LocalLeader>r3

    Go to the fourth message of the conversation:

        <LocalLeader>r4

    Go to your signature:

        <LocalLeader>S


### Launch mail client

One of Mutt main drawbacks is that you can't access your mailbox while
writing mails, good news everyone, with vim-mail you can open mutt in RO
mode easily by typing

    <LocalLeader>M

Moreover you can set the mail client command to your launcher script by
adding to your vimrc something like:

    let g:VimMailClient="/path/to/your/launcher"



