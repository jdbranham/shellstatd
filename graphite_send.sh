function sendToGraphite { read payload; echo $payload > /dev/tcp/$graphite_host/$graphite_port; }