function jolokiaRequest { 
  while IFS= read -r line; do
  	curl $line
  done
}