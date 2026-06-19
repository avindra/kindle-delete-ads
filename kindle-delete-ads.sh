#!/usr/bin/env sh

# to debug, uncomment the following 2 lines
#exec 1> /tmp/kindle-ads 2>&1
#set -x

#
# changelog
#
#  2026-06-19: merge macOS script into main script
#  2024-06-20: drop bashisms
#  2016-07-24: initial release


delete_ads() {
	kindleMount="$1"
	adverts="system/.assets"

	# We are in Kindle filesystem after this point...
	cd "$kindleMount" || exit 1

	if [ -f "$adverts" ]; then
		echo "Temp ad blocker is still intact! Nothing to do."
	elif [ -d "$adverts" ]; then
		echo "Ads detected. Cleaning time."

		printf "%s" "Deleting all ads... "
		rm -rf "$adverts"
		echo "done"

		printf "%s" "Installing temp ad blocker... "
		touch "$adverts"
		echo "done"
	fi
}

case "$(uname -s)" in
	Darwin)
		if [ -n "$1" ]; then
			kindleMount="$1"
		else
			kindleMount="/Volumes/Kindle"
		fi

		if [ -d "$kindleMount" ]; then
			echo "Kindle mounted at $kindleMount"
		else
			echo "Kindle not found. Exiting..."
			exit 1
		fi

		delete_ads "$kindleMount"
		;;
	*)
		if [ "$(id -u)" -ne 0 ]; then
			echo "Run this script with Root privileges."
			exit 1
		fi

		if [ -n "$1" ]; then
			kindleDevice="$1"
		else
			printf "%s" "Autodetecting Kindle device... "
			kindleDevice=$(blkid | grep Kindle | cut -f 1 -d ':')
			echo "done"
		fi

		if [ -z "$kindleDevice" ]; then
			echo "Kindle not found. Exiting..."
			exit 1
		fi

		echo "Kindle device file is $kindleDevice"

		if df | grep "$kindleDevice" > /dev/null; then
			echo "Kindle is already mounted! unmounting...."
			umount "$kindleDevice"
		fi

		tmpMount=$(mktemp -d)

		# note: usage of "mount" here requires explicit permission grant
		# in the udevd service file.

		# the suggested mount method doesn't work (hangs up)
		# systemd-mount --no-ask-password --no-pager --fsck=false --automount=false $kindleDevice $tmpMount

		if ! mount "$kindleDevice" "$tmpMount"; then
			echo "Failed to mount fs"
			rmdir "$tmpMount"
			exit 1
		fi

		echo "Mounting Kindle to temporary location: $tmpMount"
		delete_ads "$tmpMount"

		# Post-cleanup

		printf "%s" "Unmounting kindle... "

		cd - > /dev/null || exit 1
		umount "$kindleDevice"
		rmdir "$tmpMount"

		echo "done"
		;;
esac
