# Readme

## What is this plugin ?

This plugin is a small helper for writing mail from vim, I designed it using
mutt but it should work with other clients. I recommend to use it in
combination with [CheckAttach](https://github.com/chrisbra/CheckAttach).


## Install

### Vizardry

If you have [Vizardry](https://github.com/dbeniamine/vizardry) installed, you
can run from vim:

    :Invoke -u dbeniamine vim-mail

### Pathogen install

    git clone https://github.com/dbeniamine/vim-mail.git ~/.vim/bundle/vim-mail

### Quick install

    git clone https://github.com/dbeniamine/vim-mail.git
    cd vim-mail/
    cp -r ./* ~/.vim

## Features

This plugin provides the following features

### Contact completion

The contact completion is designed for
[pycarddav](https://pypi.python.org/pypi/pyCardDAV), however it is possible to
use any external tools, see [address book
configuration](#address-book-configuration).

To search your address book from vim:

+   While writing a mail, in insert mode, type:

        <LocalLeader>a

    or (using omnifunc)

        <C-X><C-O>

+   While editing any other file:

    As the previous mapping are only set for mail files, you need to set the
    completefunc (using omnifunc would be a bad idea):

        set completefunc=vimmail#completion#CompleteAddr

    Then use `<C-X><C-U>` (in insert mode) to trigger contact completion.

It will search for the word under the cursor in your contact list.

If you are currently in a From,To,CC or Bcc line, only mail addresses will
be proposed, else all the match will appear. More details will appear in
the preview window including contact name, type of the entry (mail, cell,
phone etc.).

To synchronise your address book, in a mail, in normal mode, type:

    <LocalLeader>a

### Redaction

####   Cursor initial position

By default vim-mail place your cursor at the beginning of the mail (right
after the headers) adds a blank line and switch to insert mode. This
behavior can be modified through a series of flags:

The available flags are:

Flag | Meaning
-----|----------------------------------------------------------------------
`i`  | insert mode
`o`  | Add new line after cursor
`O`  | Add new line before cursor
`A`  | Place cursor at the end of the line
`W`  | Start on second word (a.k.a first address of field / word of subject)
`I`  | Intelligent start: If two replies, start above on below, as the last
     | replier, else default to other flags
`t`  | top (Right after headers)
`b`  | Bottom (After last message)
`F`  | From field
`T`  | To field
`C`  | Cc field
`B`  | Bcc field
`S`  | Subject field

##### Examples

Adding the following line to your vimrc will make you start at the end of
the subject line:

    let g:VimMailStartFlags="SAi"

Or if you want to start at the end of the mail:

    let g:VimMailStartFlags="boi"

#### Easy spelllang switch

While writing mails, I often need to do switch the spell lang which can be
annoying, so this plugin provide an easy way to do it. Just type:

    <LocalLeader>l

and the plugin will switch the spelllang using a list of allowed languages.  
If the current spellang is the last allowed, it will disable spell, hit

    <LocalLeader>l

once more and you will restart with the first lang.
You can set the list of allowed langs in your vimrc:

    let g:VimMailSpellLangs=['fr', 'en', 'sp']

The default langs are french, english.

This will work for any filetype as it can be usefull for many other kind of
files.

#### Messages folds

A folding method which allows you to open are close the messages of the
conversation is provided.

### Quick in-mail navigation

With this plugin, you can easily navigate through the different par of the
mail using the following mappings:

+   Headers

    Mapping          | Effect
    -----------------|--------------------------
    `<LocalLeader>f` | Go to the From field
    `<LocalLeader>b` | Go to the Bcc field
    `<LocalLeader>c` | Go to the Cc field
    `<LocalLeader>s` | Go to the SUbject field
    `<LocalLeader>R` | Go to the Reply-To field
    `<LocalLeader>t` | Go to the Reply-To field

+   Conversation

    Mapping          | Effect
    -----------------|----------------------------------------------
    `<LocalLeader>B` | Go to the first line (after headers)
    `<LocalLeader>E` | Go to the first line after the conversation
    `<LocalLeader>r` | Go to the first message of the conversation
    `<LocalLeader>r2`| Go to the second message of the conversation
    `<LocalLeader>r3`| Go to the third message of the conversation
    `<LocalLeader>r4`| Go to the fourth message of the conversation
    `<LocalLeader>S` | Go to your signature


### Launch mail client

One of Mutt main drawbacks is that you can't access your mailbox while
writing mails, good news everyone, with vim-mail you can open mutt in RO
mode easily by typing

    <LocalLeader>M

### Send file from Vim

When you are vimming at one point, you might want to send the file you are
working on. Leaving vim to send a mail from vim is so annoying, happily there
is the solution just type: `<LocalLeader>m` and VimMail will pipe the file to
mutt.

## Mappings

All mappings can be disabled by adding the following line to your vimrc:

    let g:VimMailDoNotMap=1


+   On any file

    Mapping          | Effect
    -----------------|----------------------------------------------
    `<LocalLeader>m` | Send the current buffer
    `<LocalLeader>l` | Switch spelllang
    `<LocalLeader>M` | Open the mail client

+   On mail only

    Mapping          | Effect
    -----------------|----------------------------------------------
    `<Localleader>a` | Search the word before cursor as a contact
    `<LocalLeader>f` | Go to the From field
    `<LocalLeader>b` | Go to the Bcc field
    `<LocalLeader>c` | Go to the Cc field
    `<LocalLeader>s` | Go to the SUbject field
    `<LocalLeader>R` | Go to the Reply-To field
    `<LocalLeader>t` | Go to the Reply-To field
    `<LocalLeader>r` | Go to the first message of the conversation
    `<LocalLeader>r2`| Go to the second message of the conversation
    `<LocalLeader>r3`| Go to the third message of the conversation
    `<LocalLeader>r4`| Go to the fourth message of the conversation
    `<LocalLeader>S` | Go to your signature

## CONFIGURATION

### Address book configuration

It is possible to use another address book than pycard by setting the
following variables:

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

If you don't see the preview while using contact completion, add the following
to your vimrc (see |completeopt| |preview| ):

    set completeopt=preview

If you don't want this completion you can either not use the plugin or add
the following line to your vimrc:

    let g:VimMailDontUseComplete=1

By default, the contact completion appends the query to the result list, you
can disable this feature:

    let g:VimMailDoNotAppendQueryToResults

### Spell

Setting the list of possible spell langs:

    let g:VimMailSpellLangs=['fr', 'en', 'sp']

### Folds

To disable message folds, add the following line to your vimrc:

    let g:VimMailDoNotFold=1

### Mail Client

You can set the mail client command to your launcher script by adding to your
vimrc something like:

    let g:VimMailClient="/path/to/your/launcher"

If you are not using mutt, or want to customize the send mail command, just
add something like that to your vimrc (this is the default command):

    let g:VimMailSendCmd=":! mutt -a %"

## License

This plugin is distributed under GPL Licence v3.0, see
https://www.gnu.org/licenses/gpl.txt
