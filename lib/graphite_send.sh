function sendToGraphite { 
	if [ -z $use_python_send ]; then
		if [ -z $verbose_logging ]; then
			echo -e "sendToGraphite: Using python send\n"
			echo -e $1 >> $LOG
		fi
  		echo -e $1 | $SHELLSTATD_HOME/lib/python_send.py --server=$graphite_host --port=$graphite_port --protocol=$graphite_protocol
  	else
		while IFS= read -r line; do
			if [ -z $verbose_logging ]; then
				echo -e "sendToGraphite: Using bash send\n"
				echo -e $1 >> $LOG
			fi
			echo "$line" > /dev/$graphite_protocol/$graphite_host/$graphite_port
  		done
  	fi
}