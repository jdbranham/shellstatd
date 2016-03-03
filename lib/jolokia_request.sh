function jolokiaRequest { 
   # open file for read, assign descriptor
   exec 3<$1     
   while read -u 3 LINE
   do
       # do something with ${LINE}
       curl -s ${LINE}
   done
   # close file
   exec 3<&-    
}