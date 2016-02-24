#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
HOSTNAME=$(hostname -s)
. $SHELLSTATD_HOME/graphite_send.sh

echo "Launching vmstat monitoring, reporting data to $graphite_host"
vmstat $graphite_interval_seconds | gawk -f $SHELLSTATD_HOME/awk/vmstat.awk hostname=$HOSTNAME graphite_host=$graphite_host graphite_port=$graphite_port | sendToGraphite &
echo $! >> $PID_FILE
 
