#!/bin/sh

if [ -e /tmp/ecm.info ]; then
	cat /tmp/ecm.info
else
	echo "No /tmp/ecm.info"
fi

