# Dotfiles

If this is a new system and you want to install everything:

```bash
git submodule init
git submodule update --remote
python aliases.py
```

This will not overwite existing files, so either delete the files that have a collision, or manually create the symbolic links.
