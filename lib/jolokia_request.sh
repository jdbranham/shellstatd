# Requires json_parse.sh

jolokia_request_url=$1

echo "Send request to $jolokia_request_url"
curl $jolokia_request_url | json