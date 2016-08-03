#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
. $SHELLSTATD_HOME/lib/graphite_send.sh

echo "Launching iostat monitoring, reporting data to $graphite_host"
iostat -xm $graphite_interval_seconds | gawk -f $SHELLSTATD_HOME/awk/iostat.awk PREFIX=$PREFIX | sendToGraphite &
echo $! >> $PID_FILE 
