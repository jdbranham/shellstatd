#!/bin/bash

CONFIG_FILE=$1
. $CONFIG_FILE
. $SHELLSTATD_HOME/lib/graphite_send.sh

# get the units -- bytes or KB?
U=$(sar -n DEV 1 1 | head -4 | gawk '/IFACE/{print $6}')
if [ "$U" == "rxkB/s" ]
then
   UNITS="kb"
else
   UNITS="bytes"
fi

echo "Launching sar network monitoring, reporting data to $graphite_host"
sar -n DEV $graphite_interval_seconds 99999999999 | gawk -f $SHELLSTATD_HOME/awk/sar_network.awk \
                PREFIX=$PREFIX \
                interface=$NETWORK_INTERFACE \
                units=$UNITS | sendToGraphite &
echo $! >> $PID_FILE
 
