#!/usr/bin/env sh

# to debug, uncomment the following 2 lines
#exec 1> /tmp/kindle-ads 2>&1
#set -x

# expected mount point on mac - mounts automatically
kindleMount="/Volumes/Kindle"

if [ -d $kindleMount ]; then
	echo "Kindle mounted at $kindleMount"
else
	echo "Kindle not found. Exiting..."
        exit 1
fi

echo "Autodetecting Kindle device... "
kindleDisk=`diskutil list | grep Kindle | awk '{print $5}'`
kindleDevice="/dev/$kindleDisk"
echo "Kindle device file is $kindleDevice"

# We are in Kindle filesystem after this point...

cd $kindleMount

adverts="system/.assets"

if [ -f $adverts ]; then
	echo "Temp ad blocker is still intact! Nothing to do."
elif [ -d $adverts ]; then
	echo "Ads detected. Cleaning time."

	echo "Deleting all ads... "
	rm -rf $adverts
	echo "done"

	echo "Installing temp ad blocker... "
	touch $adverts
	echo "done"
fi
