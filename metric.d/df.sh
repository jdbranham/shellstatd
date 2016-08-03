#!/bin/bash

function repeat {
   while true
   do
      echo "$1" | /bin/bash | sendToGraphite
      sleep $graphite_interval_seconds
   done
}

CONFIG_FILE=$1
. $CONFIG_FILE
. $SHELLSTATD_HOME/lib/graphite_send.sh

echo "Launching df monitoring, reporting data to $graphite_host"
repeat "df -hP | gawk -f $SHELLSTATD_HOME/awk/df.awk PREFIX=$PREFIX"
 
