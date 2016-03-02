#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
HOSTNAME=$(hostname -s)
. $SHELLSTATD_HOME/lib/graphite_send.sh

echo "Launching mpstat monitoring, reporting data to $graphite_host"
mpstat -P ALL $graphite_interval_seconds | gawk -f $SHELLSTATD_HOME/awk/mpstat.awk hostname=$HOSTNAME | sendToGraphite &
echo $! >> $PID_FILE
 
