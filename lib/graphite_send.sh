function sendToGraphite { 
	if [ $use_python_send ]; then
  		echo -e $1 | $SHELLSTATD_HOME/lib/python_send.py --server=$graphite_host --port=$graphite_port --protocol=$graphite_protocol
  	else
		while IFS= read -r line; do
			echo "$line" > /dev/$graphite_protocol/$graphite_host/$graphite_port
  		done
  	fi
}