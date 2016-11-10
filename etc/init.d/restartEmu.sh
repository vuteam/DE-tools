#!/bin/sh

remove_tmp () {
	rm -rf /tmp/ecm.info
}

[ -e /usr/bin/csactive ] && export SRVACTIVE=$(cat /usr/bin/csactive)
[ -e /usr/bin/emuactive ] && export EMUACTIVE=$(cat /usr/bin/emuactive)

remove_tmp
[ -e /usr/bin/emuactive ] && /usr/script/${EMUACTIVE}_em.sh stop
[ -e /usr/bin/csactive ] && /usr/script/${SRVACTIVE}_cs.sh stop
sleep 1
if [ -z "${SRVACTIVE}" ]; then
[ -e /usr/bin/emuactive ] && /usr/script/${EMUACTIVE}_em.sh start
else
[ -e /usr/bin/csactive ] && /usr/script/${SRVACTIVE}_cs.sh start
sleep 7
[ -e /usr/bin/emuactive ] && /usr/script/${EMUACTIVE}_em.sh start
fi
exit 0

