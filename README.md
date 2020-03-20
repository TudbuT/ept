# ept

This is an easy way to install and search apps.

## IMPORTANT: Keep ept up-to-date!
You should run `ept install ept` from time to time!
Also: Whenever anything doesn't work, try full-updating too: `ept install ept ; ept update_list`
   When even that doesn't help, reinstall ept using `apt remove ept` (Yes, apt!) and then reinstall it using the .deb file!

### Suggestions for search engine
- How to submit:
  - PR of ept_applist.eptlist
- What to submit:
  - You can submit any application you want, it is a good idea to go ahead and just submit any app you like!
  - You should submit in this format, any submission which does not follow this format, gets ignored and deleted.
    - `[newline]< application ID (for 'ept install <ID>') >::< commands, the application adds>::< full name of the application >::< description of the application >::< tags (tag1 tag2 tag3) >::< installation type (__d__ for the default, __c__ for custom or {package manager} (will run '{package manager} install {app}') >::< [only if installation type is __c__[the installation command(s)]] >`
    - NO newline at the end!!!
