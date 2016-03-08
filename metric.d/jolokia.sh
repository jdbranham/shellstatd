#!/bin/bash

# expects a multi-attribute value format -
# {"request":{"mbean":"java.lang:type=Memory","attribute":"HeapMemoryUsage","type":"read"},"value":{"init":2147483648,"committed":2112618496,"max":2112618496,"used":1340033832},"timestamp":1456952652,"status":200}
#
# or a single value format -
# {"request":{"mbean":"java.lang:name=ParNew,type=GarbageCollector","attribute":"CollectionTime","type":"read"},"value":177657,"timestamp":1456952949,"status":200}


function repeatJolokia {
   while true
   do
      echo -e `$1` | sendToGraphite
      sleep $graphite_interval_seconds
   done
}

CONFIG_FILE=$1
. $CONFIG_FILE
HOSTNAME=$(hostname -s)
. $SHELLSTATD_HOME/lib/graphite_send.sh
. $SHELLSTATD_HOME/lib/jolokia_request.sh
JOLOKIA_URLS=$SHELLSTATD_HOME/conf/jolokia.conf

echo "Launching jolokia monitoring, reporting data to $graphite_host"
repeatJolokia "jolokiaRequest $JOLOKIA_URLS"
 
