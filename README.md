**Dotfiles**

To synchronize my setting over all my computers I'm using this git repository and a dotfiles management tool.

- clone my own dotfiles from this repository into '$HOME/dotfiles'.
- copy the '$HOME/dotfiles/.dotfilesrc' file to the '$HOME/'
- clone dotfiles management tool into '$HOME/dotfiles/.bin/dotfiles'
- reset head revision of the dotfiles management tool to 83c8d55
- execute '$HOME/dotfiles/.bin/dotfiles/bin/dotfiles -s'.
- create a 'bin' symlink in my home directory 'ln -s .bin bin'. Where '.bin/' is a symlink created by the dotfiles manager and it points to the '$HOME/dotfiles/.bin'

Dotfiles management tool I'm using can be cloned from the jbernard's github:
```
    $ git clone https://github.com/jbernard/dotfiles
    $ cd dotfiles
    $ ./dotfiles --help
```

**Resetting dotfiles management tool git revision to 83c8d55**

The tinfoil hatter who has developed the tool has added more python lib dependencies which I don't want. So I just hard reset the HEAD of his git repo:

```
$ git clone https://github.com/jbernard/dotfiles
$ git checkout 83c8d55
$ git reset --hard
```

**Installing Vim plugins**

To install all needed vim plugins:
```
$ bin/vim_install_plugins.sh
```

