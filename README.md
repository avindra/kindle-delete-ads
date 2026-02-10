# kindle-delete-ads

## Installation

The recommended installation is to your local `bin` folder (it should be in your `$PATH` by default).

```bash
wget -P ~/bin https://raw.githubusercontent.com/avindra/kindle-delete-ads/main/kindle-delete-ads.sh
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

It works on Linux, macOS and should work on other \*nix systems.

Use [`kindle-delete-ads-mac.sh`](./kindle-delete-ads-mac.sh) on macOS

## Why

Deleting the `.assets` folder will work, but is only a temporary fix. I would recommend using this script to purge your Kindle when necessary, and keeping your Kindle in airplane mode so that it doesn't try to fetch more ads. Usage of airplane mode should also extend your battery life.


# Autorun on plug in

To make life as easy as possible, have your computer wipe the Kindles ads every time you plug it in.

Unfortunately [since June 2018, udevd service has been restricted to a limited set of syscalls](https://github.com/systemd/systemd/commit/ee8f26180d01e3ddd4e5f20b03b81e5e737657ae#r143372255), notably missing `@mount`. To work around this, add `@mount` to `SystemCallFilter` in `/usr/lib/systemd/system/systemd-udevd.service`, or simply comment out the entire `SystemCallFilter` line.

To continue without restarting your system, run:

```sh
sudo systemctl restart systemd-udevd
sudo systemctl daemon-reload

sudo udevadm control --reload-rules
sudo udevadm trigger
```

Afterwards, add a file to `/etc/udev/rules.d` called `99-kindle.rules`.

```sh
ACTION=="add", ENV{DEVTYPE}=="partition", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", RUN+="/home/avindra/bin/kindle-delete-ads.sh '%E{DEVNAME}'"
```

*NOTE*: Your `idProduct` will probably differ, depending on the Kindle model you have. Additionally, be sure to set the script path in `RUN` to the location where you have installed this script.
