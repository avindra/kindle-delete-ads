# kindle-delete-ads

## Installation

The recommended installation is to the `bin` folder of your regular user's home folder, as this should be in your `$PATH` by default.

```bash
wget -P ~/bin https://raw.githubusercontent.com/avindra/kindle-delete-ads/master/kindle-delete-ads.sh
chmod +x ~/bin/kindle-delete-ads.sh
```


## Usage

```bash
$ sudo kindle-delete-ads.sh
 Kindle device file is /dev/sde1
 Mounting Kindle to temporary location: /tmp/tmp.jIUXPogGgC
 Ads detected. Cleaning time.
 Deleting all ads... done
 Installing temp ad blocker... done
 Unmounting kindle... done

# Will do nothing if ad blocker is in place

$ sudo kindle-delete-ads.sh
 Kindle device file is /dev/sde1
 Mounting Kindle to temporary location: /tmp/tmp.q1jNYEkwex
 Temp ad blocker is still intact! Nothing to do.
 Unmounting kindle... done
```

## How

Kindle stores the cover ads on the lock screen in a system folder called `.assets`. This is a script which automates the well known hack.

It works on Linux, and should work on other \*nix systems.

It will not work on macOS, because it uses `blkid`. If you want to create a PR for macOS support, feel free.


## Why

Deleting the `.assets` folder will work, but is only a temporary fix. I would recommend using this script to purge your Kindle when necessary, and keeping your Kindle in airplane mode so that it doesn't try to fetch more ads. Usage of airplane mode should also extend your battery life.


# Autorun on plug in

You can really make life as easy as possible by having your computer wipe the Kindles ads every time you plug it in. Add a file to `/etc/udev/rules.d` called `kindle.rules`:

```
ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", RUN+="/usr/local/share/kindle-wrapper.sh"
```

*NOTE*: Your `idProduct` will probably differ, depending on the Kindle model you have.

Make a script called `/usr/local/share/kindle-wrapper.sh`:

```bash
#!/bin/bash
if [[ "${ACTION}" == "add" ]]; then
    if [[ "${ID_FS_VERSION}" == "FAT32" && "${DEVTYPE}" == "partition" ]]; then
        export PATH=$PATH:/sbin # sbin is needed for blkid
        /home/avindra/bin/kindle-delete-ads.sh >> /tmp/kindlog.txt
    fi
fi
```

*NOTE*: Be sure to set the correct location to the script in your wrapper.