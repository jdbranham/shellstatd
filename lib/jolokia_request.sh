function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1
   while read -u 3 LINE
   do
       # do something with ${LINE}
       curl -s ${LINE} | $SHELLSTATD_HOME/lib/JSON.sh -b | egrep '\["value"\]'
   done
   # close file
   exec 3<&-
}