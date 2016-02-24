function sendToGraphite { 
  while IFS= read -r line; do
    echo "$line" > /dev/tcp/$graphite_host/$graphite_port
  done < $1
}