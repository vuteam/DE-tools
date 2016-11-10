#!/bin/sh

no_file()
{
echo "===================================================="
echo ""
echo "Sorry, no entitlements file available..."
echo "Check your card insertion and"
echo "be sure to set in oscam.conf"
echo "the parameter \"saveinithistory = 1\""
echo "under [global] section..."
echo ""
echo "===================================================="
}
if [ -d /tmp/.oscam ]; then
	cd /tmp/.oscam
	ls -1 | while read fn; do
		if [ -e $fn ]; then
			echo ""
			echo "$fn entitlements..."
			echo "===================================================="
			cat $fn
			echo "===================================================="
			echo ""
		else
			no_file
		fi
	done
else
	no_file
fi
exit 0