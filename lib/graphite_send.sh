function sendToGraphite { 
	if [ $use_python_send == true ]; then
		if [  $verbose_logging == "True"  ]; then
			echo -e "sendToGraphite: Using python send." >> $LOG
		fi
  		cat $1 | $SHELLSTATD_HOME/lib/python_send.py --server=$graphite_host --port=$graphite_port --protocol=$graphite_protocol --verbose=$verbose_logging --source-ip=$SOURCE_IP
  	else
		while IFS= read -r line; do
			if [  $verbose_logging == "True"  ]; then
				echo -e "sendToGraphite: Using bash send." >> $LOG
			fi
			echo "$line" > /dev/$graphite_protocol/$graphite_host/$graphite_port
  		done < <(cat $1)
  	fi
}