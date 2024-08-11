pass -c $(find ~/.password-store/ -name '*.gpg' | sed -e 's:^.*password-store/\(.*\).gpg$:\1:g' | fzf)
