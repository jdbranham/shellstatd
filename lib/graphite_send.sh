function sendToGraphite { 
	if [ $use_python_send == true ]; then
		if [  $verbose_logging == "true"  ]; then
			echo -e "sendToGraphite: Using python send\n" >> $LOG
			echo -e $1 >> $LOG
		fi
  		echo -e $1 | $SHELLSTATD_HOME/lib/python_send.py --server=$graphite_host --port=$graphite_port --protocol=$graphite_protocol --verbose=$verbose_logging
  	else
		while IFS= read -r line; do
			if [  $verbose_logging == "true"  ]; then
				echo -e "sendToGraphite: Using bash send\n" >> $LOG
				echo -e $1 >> $LOG
			fi
			echo "$line" > /dev/$graphite_protocol/$graphite_host/$graphite_port
  		done
  	fi
}