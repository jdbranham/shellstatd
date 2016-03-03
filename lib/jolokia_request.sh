function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1     
   tmpfile=$(mktemp $2)
   while read -u 3 LINE
   do
       # do something with ${LINE}
       curl -s ${LINE} > $tmpfile
   done
   # close file
   exec 3<&-    
   $SHELLSTATD_HOME/lib/JSON.sh $tmpfile
   rm $tmpfile
}