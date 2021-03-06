#!/bin/bash

# get the install dir on the cmd line
INSTALL_DIR=$1
GRAPHITE_HOST=$2
MONITOR_INTERVAL=$3
GRAPHITE_PORT=$4
DEFAULT_GRAPHITE_PORT="2003"

CONFIG="$INSTALL_DIR/conf/shellstatd.conf"
PID_FILE="$INSTALL_DIR/.shellstatd.pid"
INIT_DIR="$INSTALL_DIR"

# check for root
if [ $UID == "0" ]
then
   CONFIG="/etc/shellstatd.conf"
   PID_FILE="/var/run/.shellstatd.pid"
   INIT_DIR="/etc/init.d"
fi

# check for current directory
if ! ls awk/vmstat.awk > /dev/null 2>&1
then
   echo "Installer must be run from the shellstatd directory."
   exit 1
fi


if [ "$MONITOR_INTERVAL" == "" ]
then
   echo "Usage: install.sh <install dir> <graphite host> <monitor interval seconds> [ graphite port (default=2003) ]"
   exit 1
fi
mkdir -p $INSTALL_DIR/log
mkdir -p $INSTALL_DIR/conf
if [ "$GRAPHITE_PORT" == "" ]
then
   GRAPHITE_PORT=$DEFAULT_GRAPHITE_PORT
fi

echo "Installing shellstatd."
echo "   INSTALL_DIR: $INSTALL_DIR"
echo "   GRAPHITE_HOST: $GRAPHITE_HOST"
echo "   MONITOR_INTERVAL: $MONITOR_INTERVAL"
echo "   GRAPHITE_PORT: $GRAPHITE_PORT"
echo "   CONFIG: $CONFIG"
echo "   PID_FILE: $PID_FILE"
echo "   INIT_DIR: $INIT_DIR"
echo "   LOG: $INSTALL_DIR/log/graphite.log"

echo "SHELLSTATD_HOME=\"$INSTALL_DIR\"" > $CONFIG
echo "PID_FILE=\"$PID_FILE\"" >> $CONFIG
echo "LOG=\"$INSTALL_DIR\"/log/graphite.log" >> $CONFIG
echo >> $CONFIG

# copy bits to new dir
rsync -av * $INSTALL_DIR --exclude ".svn" --exclude ".gitignore" --exclude="install.sh"
chmod +x $INSTALL_DIR/metric.d/*
chmod +x $INSTALL_DIR/lib/*
chmod +x test/*
cat conf/shellstatd.starter.conf >> $CONFIG
touch $INSTALL_DIR/conf/jolokia.conf
touch $INSTALL_DIR/log/graphite.log
cp shellstatd $INIT_DIR
mkdir -p $INSTALL_DIR/log

echo "graphite_host=\"$GRAPHITE_HOST\"" >> $CONFIG
echo "graphite_port=\"$GRAPHITE_PORT\"" >> $CONFIG
echo "graphite_interval_seconds=\"$MONITOR_INTERVAL\"" >> $CONFIG


#if ! sar 1 1 > /dev/null 2>&1
#then
#   echo "WARNING: sysstat system package not found.  iostat and sar"
#   echo "         monitoring tools will be unavailable."
#fi

echo "shellstatd installed successfully to $INSTALL_DIR"


