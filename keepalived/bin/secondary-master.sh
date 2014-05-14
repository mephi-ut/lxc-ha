#!/bin/bash
PATH=/opt/lxc/bin:/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin

date +"[%Y-%m-%d %H:%M:%S] secondary-master" >> /var/log/ha.log

ANTIFLAPPING_TIMEOUT=45

while [ "$SECONDS" -lt "$ANTIFLAPPING_TIMEOUT" ]; do
	if lxc-checkbrother; then
		exit 0
	fi
	sleep 1
done

for pidfile in /var/run/clsync-*-brother.pid; do 
	pkill -F $pidfile
done

bash -x lxc-pickup-start 2>/tmp/lxc-pickup-start.log

exit 0

