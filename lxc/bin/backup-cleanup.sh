#!/bin/bash

BROTHER=$(brothername)

SSHOPTS='
-o TCPKeepAlive=yes
-o ControlMaster=auto
-o ControlPath=~/.ssh/master-%r@%h:%p
-o ConnectTimeout=1
'

if [ "$(ssh -o ConnectTimeout=1 -o ControlMaster=no "getroot@$BROTHER" echo CHECK 2>/dev/null)" != "CHECK" ]; then
	echo Cannot connect with brother.
        exit
fi

if ! [ -S ~/.ssh/"master-getroot@$BROTHER:22" ]; then
	screen -S backupcleanupsshtobrother$$ -dm ssh $SSHOPTS "getroot@$BROTHER"
fi

for CONTAINER in $(lxc-ls); do
	REMOTESTATUS="$(ssh $SSHOPTS getroot@$BROTHER lxc-status "$CONTAINER")"
	if [ "$REMOTESTATUS" = "RUNNING" ]; then
		rm -rf /mnt/backup/mirror/"$CONTAINER"
	fi
done


