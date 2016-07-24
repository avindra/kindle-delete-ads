#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "Run this script with Root priveleges."
	exit 1
fi

kindleDevice=`blkid | grep Kindle | cut -f 1 -d ':'`

echo "Kindle device file is $kindleDevice"

mountInfo=`df | grep $kindleDevice`
if [[ $? -eq 0 ]]; then
	echo "Kindle is already mounted! unmounting...."
	umount $kindleDevice
fi


tmpMount=`mktemp -d`
echo "Mounting Kindle to temporary location: $tmpMount"
mount $kindleDevice $tmpMount


# We are in Kindle filesystem after this point...

cd $tmpMount

adverts="system/.assets"

if [[ -f $adverts ]]; then
	echo "Temp ad blocker is still intact! Nothing to do."
elif [[ -d $adverts ]]; then
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
