#!/bin/bash

# expects a multi-attribute value format -
# {"request":{"mbean":"java.lang:type=Memory","attribute":"HeapMemoryUsage","type":"read"},"value":{"init":2147483648,"committed":2112618496,"max":2112618496,"used":1340033832},"timestamp":1456952652,"status":200}
#
# or a single value format -
# {"request":{"mbean":"java.lang:name=ParNew,type=GarbageCollector","attribute":"CollectionTime","type":"read"},"value":177657,"timestamp":1456952949,"status":200}


function repeatJolokia {
   while true
   do
      echo "$1" | /bin/bash 
      sleep $graphite_interval_seconds
   done
}

CONFIG_FILE=$1
. $CONFIG_FILE
HOSTNAME=$(hostname -s)

. $SHELLSTATD_HOME/lib/graphite_send.sh
echo "Imported $SHELLSTATD_HOME/lib/graphite_send.sh"

#JSON_SEPARATOR="."
echo "Set JSON_SEPARATOR=$JSON_SEPARATOR"

. $SHELLSTATD_HOME/lib/json_parse.sh
echo "Imported $SHELLSTATD_HOME/lib/json_parse.sh"

JOLOKIA_URLS=$SHELLSTATD_HOME/conf/jolokia.conf
echo "Imported $SHELLSTATD_HOME/conf/jolokia.conf"

. $SHELLSTATD_HOME/lib/jolokia_request.sh
echo "Imported $SHELLSTATD_HOME/lib/jolokia_request.sh"

exec 3<$JOLOKIA_URLS
echo "Launching jolokia monitoring, reporting data to $graphite_host"
repeatJolokia "while read -u 3 url; do jolokia_request $url; done; exec 3<&-"
 
