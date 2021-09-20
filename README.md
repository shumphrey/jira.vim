🙈 Jira.vim 🙈
==============

Everyone's Jira is configured differently.
This is unlikely to work for anyone else.

Configuration
-------------

In your vimrc:

```
let g:jira_domain = 'https://my.jira.com'
```

Completions
-----------

Type \<project\>-\<search term\> then trigger omnicomplete (`ctrl-x ctrl-o` by default)

Authentication
--------------

This plugin currently assumes curl can talk to your Jira without vim configuration.
e.g. ~/.curlrc contains everything your curl needs to talk to your Jira.

Popups and Preview Menus
------------------------

If you have a modern vim try:

```vim
set completeopt+=popup
```

That might subjectively produce a nicer completion experience.

If you don't have popup support and you don't like the preview window, you
can remove the preview window with

```vim
set completeopt-=preview
```

Working with GitHub, GitLab or other git repos
----------------------------------------------

Sometimes you use Jira for issue completion but you might want to still complete
other things from the GitHub or other providers.

TODO: document this.
