#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
. $SHELLSTATD_HOME/lib/graphite_send.sh

echo "Launching sar load monitoring, reporting data to $graphite_host"
sar -q $graphite_interval_seconds 99999999999 | gawk -f $SHELLSTATD_HOME/awk/sar_load.awk PREFIX=$PREFIX | sendToGraphite &
echo $! >> $PID_FILE
 
