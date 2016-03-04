function sendToGraphite { 
  while IFS= read -r line; do
    echo "$line" > /dev/$graphite_protocol/$graphite_host/$graphite_port
    echo "$line" >> $LOG_FILE 
  done
}