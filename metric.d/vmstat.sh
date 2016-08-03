#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
. $SHELLSTATD_HOME/lib/graphite_send.sh

echo "Launching vmstat monitoring, reporting data to $graphite_host"
vmstat $graphite_interval_seconds | gawk -f $SHELLSTATD_HOME/awk/vmstat.awk PREFIX=$PREFIX | sendToGraphite &
echo $! >> $PID_FILE
 
