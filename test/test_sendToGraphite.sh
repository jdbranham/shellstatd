#!/bin/bash

echo -e "Testing udp\n"

use_python_send=false
graphite_protocol=udp
graphite_host=127.0.0.1
graphite_port=2003

. ../lib/graphite_send.sh

cat example.txt | sendToGraphite