#!/usr/bin/env sh

# to debug, uncomment the following 2 lines
# exec 1> /tmp/kindle-ads 2>&1
# set -x

#
# changelog
#
#  2024-06-20: drop bashims, use standard shell
#  2016-07-24: initial release


if [ $EUID -ne 0 ]; then
	echo "Run this script with Root priveleges."
	exit 1
fi

if [ -n "$1" ]; then
	kindleDevice="$1"
else
	echo -n "Autodetecting Kindle device... "
	kindleDevice=`blkid | grep Kindle | cut -f 1 -d ':'`
	echo "done"
fi

echo "Kindle device file is $kindleDevice"

mountInfo=`df | grep $kindleDevice`
if [ $? -eq 0 ]; then
	echo "Kindle is already mounted! unmounting...."
	umount $kindleDevice
fi

tmpMount=`mktemp -d`

# note: usage of "mount" here requires explicit permission grant
# in the udevd service file.
mount $kindleDevice $tmpMount

# the suggested mount method doesn't work (hangs up)
# systemd-mount --no-ask-password --no-pager --fsck=false --automount=false $kindleDevice $tmpMount

if [ $? -ne 0 ] ; then
	echo "Failed to mount fs"
	exit 1
fi

# We are in Kindle filesystem after this point...

cd $tmpMount

adverts="system/.assets"

echo "Mounting Kindle to temporary location: $tmpMount"


if [ -f $adverts ]; then
	echo "Temp ad blocker is still intact! Nothing to do."
elif [ -d $adverts ]; then
	echo "Ads detected. Cleaning time."

	echo -n "Deleting all ads... "
	rm -rf $adverts
	echo "done"

	echo -n "Installing temp ad blocker... "
	touch $adverts
	echo "done"
fi

# Post-cleanup for this utility

echo -n "Unmounting kindle... "

cd - > /dev/null
umount $kindleDevice
rmdir $tmpMount

echo "done"
