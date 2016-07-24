# kindle-delete-ads

Usage

```bash
sudo ./kindle-delete-ads.sh
```

## How

Kindle stores the cover ads on the lock screen in a system folder called `.assets`. This is a script which automates the well known hack.

It works on Linux, and should work on other *nix systems.

It will not work on macOS, because it uses `blkid`. If you want to create a PR for macOS support, feel free.


## Why

Deleting the `.assets` folder will work, but is only a temporary fix. I would recommend using this script to purge your Kindle when necessary, and keeping your Kindle in airplane mode so that it doesn't try to fetch more ads. Usage of airplane mode should also extend your battery life.
