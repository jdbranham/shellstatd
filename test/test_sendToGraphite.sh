#!/bin/bash

echo -e "NOTE: Run from SHELLSTATD_HOME\n"
echo -e "Requires a TCP and UDP server running locally\n"

use_python_send=false
graphite_protocol=udp
graphite_host=127.0.0.1
graphite_port=2003
SHELLSTATD_HOME=`pwd`

. $SHELLSTATD_HOME/lib/graphite_send.sh


echo -e "#### Testing udp with bash ####\n"
cat $1 | sendToGraphite

echo -e "#### Testing udp with python ####\n"
use_python_send=true
cat $1 | sendToGraphite

echo -e "#### Testing tcp with bash ####\n"
use_python_send=false
graphite_port=2004
graphite_protocol=tcp
cat $1 | sendToGraphite

echo -e "#### Testing tcp with python ####\n"
use_python_send=true
cat $1 | sendToGraphite