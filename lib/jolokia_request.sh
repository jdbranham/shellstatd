#!/bin/bash

# Requires JSON.sh

function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1
   while read -u 3 LINE
   do
      local TEMP_FILE=(mktemp)
      curl -s ${LINE} | $SHELLSTATD_HOME/lib/JSON.sh -b > $TEMP_FILE
      local MBEAN_NAME=`extractMBeanName $TEMP_FILE`
      local MBEAN_ATTRIBUTE=`extractMBeanAttribute $TEMP_FILE`
      local MBEAN_VALUE=`extractMBeanValue $TEMP_FILE`
      local MBEAN_TIMESTAMP=`extractMBeanTimestamp $TEMP_FILE`
      rm $TEMP_FILE
      #echo -e "MBEAN_NAME: $MBEAN_NAME\n"
      #echo -e "MBEAN_ATTRIBUTE: $MBEAN_ATTRIBUTE\n"
      #echo -e "MBEAN_VALUE: $MBEAN_VALUE\n"
      #echo -e "MBEAN_TIMESTAMP: $MBEAN_TIMESTAMP\n"
      
      local PAYLOAD=()
      case $MBEAN_VALUE in
         # The value is not a number
         ''|*[!0-9]*) 
            while read -r value_entry
            do
               local full_string="$MBEAN_NAME$MBEAN_ATTRIBUTE $value_entry $MBEAN_TIMESTAMP"
               PAYLOAD+=("${full_string}")
            done < <(echo "$MBEAN_VALUE") ;;
         # The value must be a number
         *) 
            local full_string="$MBEAN_NAME$MBEAN_ATTRIBUTE $MBEAN_VALUE $MBEAN_TIMESTAMP"
            PAYLOAD+=("${full_string}") ;;
      esac
      for payload_item in "${PAYLOAD[*]}"; do
         echo -e "$payload_item\n"
      done
   done
   # close file
   exec 3<&-
}

function extractMBeanName {
   local TEMP_FILE=$1
   local MATCH='\["request","mbean"\]'
   local MBEAN="`egrep $MATCH $TEMP_FILE`"
   #echo -e "First - $MBEAN\n"
   MBEAN="${MBEAN/$MATCH/$HOSTNAME}" 
   MBEAN="${MBEAN//':type'/}" 
   MBEAN="${MBEAN//':name'/}" 
   #echo -e "Second: $MBEAN\n"
   echo $MBEAN | sed -r 's/[\ ]//g;s/[=,\"]/./g' 
}

function extractMBeanAttribute {
   local TEMP_FILE=$1
   local MATCH='\["request","attribute"\]'
   local MBEAN="`egrep $MATCH $TEMP_FILE`"
   echo $MBEAN | awk '{print $2}' | sed 's/\"//g'
}

function extractMBeanValue {
   local TEMP_FILE=$1
   local MATCH='\["value"'
   local MBEAN="`egrep $MATCH $TEMP_FILE`"
   MBEAN="${MBEAN//'value'/}" 
   echo $MBEAN | sed -r 's/\,//g;s/\[//g;s/\]//g;s/\"//g;s/[0-9]+/&\n/g' | awk '{print $1, $2}'
}

function extractMBeanTimestamp {
   local TEMP_FILE=$1
   local MATCH='\["timestamp"\]'
   local MBEAN="`egrep $MATCH $TEMP_FILE`"
   echo $MBEAN | awk '{ print $2 }'
}