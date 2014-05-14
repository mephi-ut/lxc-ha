#!/bin/bash
PATH=/opt/lxc/bin:/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin

date +"[%Y-%m-%d %H:%M:%S] secondary-slave" >> /var/log/ha.log

exit 0

if lxc-waitforbrother; then
        lxc-pickup-stop 2>/tmp/lxc-pickup-stop.log
fi

exit 0

