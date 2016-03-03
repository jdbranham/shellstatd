function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1
   TEMP_FILE=(mktemp)
   MATCH_BEAN='\["request","mbean"\]'
   MATCH_BEANTYPE=':type='
   while read -u 3 LINE
   do
       # do something with ${LINE}
       curl -s ${LINE} | $SHELLSTATD_HOME/lib/JSON.sh -b > $TEMP_FILE | egrep '\["value"\]'
       local MBEAN=${(egrep $MATCH_BEAN $TEMP_FILE)/$MATCH_BEAN/$HOSTNAME}
       $MBEAN=${MBEAN/$MATCH_BEANTYPE/\.}
       echo $MBEAN
   done
   # close file
   exec 3<&-
}