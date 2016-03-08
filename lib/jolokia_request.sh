#!/bin/bash

# Requires JSON.sh

function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1
   while read -u 3 LINE
   do
      local PREFIX=$graphite_prefix
      local TEMP_FILE=(mktemp)
      curl -s ${LINE} | $SHELLSTATD_HOME/lib/JSON.sh -b -n > $TEMP_FILE
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
      local regexNumber='^[0-9]+$'
      if [[ "$MBEAN_VALUE" =~ $regexNumber ]]; then
         # The value is a number
         local full_string="$PREFIX$MBEAN_NAME$MBEAN_ATTRIBUTE $MBEAN_VALUE $MBEAN_TIMESTAMP\n"
         PAYLOAD+=("${full_string}") 
      else
         while read -r value_entry; do
            if [ ! "$value_entry" = "" ]; then
               local full_string="$PREFIX$MBEAN_NAME$MBEAN_ATTRIBUTE.$value_entry $MBEAN_TIMESTAMP\n"
               PAYLOAD+=("${full_string}")
            fi
         done < <(echo -e "$MBEAN_VALUE")
      fi
      for payload_item in "${PAYLOAD[*]}"; do
         echo -e "$payload_item"
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
   echo $MBEAN | sed -r 's/\ //g;s/[=,\"]/./g' | awk '{print $1}'
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
   local MBEAN_VALUE=`echo $MBEAN | sed -r 's/\,//g;s/\[//g;s/\]//g;s/\"//g;/^\s*$/d'`
   local regexNumber='^[0-9]+$'
      if [[ ! "$MBEAN_VALUE" =~ $regexNumber ]]; then
         # The value is not a number
         echo $MBEAN_VALUE | sed -r 's/[0-9]+/&\n/g' | awk '{print $1, $2}'
      else
         echo $MBEAN_VALUE | sed -r 's/[0-9]+/&/g'
   fi
   
}

function extractMBeanTimestamp {
   local TEMP_FILE=$1
   local MATCH='\["timestamp"\]'
   local MBEAN="`egrep $MATCH $TEMP_FILE`"
   echo $MBEAN | awk '{ print $2 }' | sed -r '/^\s*$/d'
}