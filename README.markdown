# Readme

## Anounces

Since v0.2.7 Vim-mail can handle (virtually) any contact providers, this implies
a few configuration changes.

see
[contacts completion](#contacts-completion)
and
[Address book configuration](#address-book-coniguration)
and maybe
[Adding a contact provider](adding-a-contact-provider).

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

The contact completion can handled virtually any address book management
command, currently only `pc_query` is officially supported see [address book
configuration](#address-book-configuration) and
[Adding a contact provider](adding-a-contact-provider).

To search your address book from vim:

+   While writing a mail, in insert mode, type:

        <LocalLeader>a

    or (using omnifunc)

        <C-X><C-O>

+   While editing any other file:

    As the previous mapping are only set for mail files, you need to set the
    completefunc (using omnifunc would be a bad idea):

        set completefunc=vimmail#contacts#CompleteAddr

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
`r`  | Remove quoted signatures from reply
`i`  | insert mode
`o`  | Add new line after cursor
`O`  | Add new line before cursor
`A`  | Place cursor at the end of the line
`W`  | Start on second word (a.k.a first address of field / word of subject)
`I`  | Intelligent start: If two replies, start above or below, as the last
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

    Mapping            | Effect
    -------------------|----------------------------------------------
    `<Localleader>a`   | Search the word before cursor as a contact
    `<LocalLeader>f`   | Go to the From field
    `<LocalLeader>b`   | Go to the Bcc field
    `<LocalLeader>c`   | Go to the Cc field
    `<LocalLeader>s`   | Go to the SUbject field
    `<LocalLeader>R`   | Go to the Reply-To field
    `<LocalLeader>t`   | Go to the Reply-To field
    `<LocalLeader>r`   | Go to the first message of the conversation
    `<LocalLeader>r2`  | Go to the second message of the conversation
    `<LocalLeader>r3`  | Go to the third message of the conversation
    `<LocalLeader>r4`  | Go to the fourth message of the conversation
    `<LocalLeader>S`   | Go to your signature
    `<LocalLeader>kqs` | Kill Quoted Signatures

## CONFIGURATION

### Address book configuration

Currently only `pc_query` (default) and `khard` are supported. You can set your
provider using

    let g:VimMailContactsProvider='pc_query'

You can also change query and sync commandsby adding the following to your
vimrc (adapting the commands) :

    if(!exists("g:VimMailContactsCommands"))
        let g:VimMailContactsCommands = {}
    endif
    let g:VimMailContactsCommands['pc_query']={ 'query' : "pc_query",
                \'sync': "pycardsyncer"}


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

## Adding a contact provider

Adding a contact provider is now a simple task for anyone who already wrote
some vimscript. To add a provider for the command `my_abook`, one needs to

1. Copy `autoload/vimmail/contacts/pc_query.vim` to
`autoload/vimmail/contacts/my_abook.vim`
2. Rename the functions replacing `pc_query` by `my_abook`
3. Same for the dictionnary at the beginnig
4. Adapts both functions
    + To write the complete function see `:help completefunc`, it should return
    a list of results, each results being a dictionnaty, containing :
        + `word` : the replacement to write
        + `kind` : the kind of result itis (`M` mail, `C` for `T` for
        Telephone)
        + `menu` : a bit more info like `cell`, `work`, `personnal`
        + `abbr` for email adresses, only the email (instead of `first last <email>`)
        + `info` : supplementary field info (usually the name of the contact
        and the full line of the provider command)
    + The sync function is trivial


## License

This plugin is distributed under GPL Licence v3.0, see
https://www.gnu.org/licenses/gpl.txt
