function jolokiaRequest { 
   FILENAME=$1
   exec 3<${FILENAME}     # open file for read, assign descriptor
   while read -u $3 LINE
   do
       # do something with ${LINE}
       echo ${LINE}
   done
   exec 3<&-    # close file
}