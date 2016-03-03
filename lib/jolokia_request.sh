#!/bin/bash

# Requires JSON.sh

function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1
   while read -u 3 LINE
   do
      local TEMP_FILE=(mktemp)
      # do something with ${LINE}
      curl -s ${LINE} | $SHELLSTATD_HOME/lib/JSON.sh -b > $TEMP_FILE
      local MBEAN_NAME=`extractMBeanName $TEMP_FILE`
      rm $TEMP_FILE
      echo $MBEAN_NAME
   done
   # close file
   exec 3<&-
}

function extractMBeanName {
   local TEMP_FILE=$1
   local MATCH_BEAN='\["request","mbean"\]'
   local MATCH_BEANTYPE='\:type\='
   local MBEAN="`egrep $MATCH_BEAN $TEMP_FILE`"
   MBEAN="${MBEAN/$MATCH_BEAN/$HOSTNAME}" | sed 's/$MATCH_BEANTYPE//' | sed 's/[\", ]//'
   echo $MBEAN
   # $MBEAN=${MBEAN/\'MATCH_BEANTYPE\'/\.}
}