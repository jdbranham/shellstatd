function sendToGraphite { 
  while IFS= read -r line; do
    echo "$line" | tee $LOG_FILE | /dev/$graphite_protocol/$graphite_host/$graphite_port
  done
}